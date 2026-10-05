#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "AvroParser.h"
#import "RegexParser.h"
#import "RegexKitLite.h"
#import "Database.h"
#import "AutoCorrect.h"
#import "NSString+Levenshtein.h"

static void require(BOOL condition, NSString *message) {
    if (!condition) {
        fprintf(stderr, "FAIL %s\n", [message UTF8String]);
        exit(1);
    }
}

int main(void) {
    @autoreleasepool {
        NSBundle *bundle = [NSBundle mainBundle];
        // Validate before invoking legacy loaders, which assume resources exist.
        NSArray *resources = @[@"data.json", @"regex.json", @"database.db3",
            @"autodict.dct", @"preferences.plist", @"avro.icns",
            @"English.lproj/MainMenu.nib", @"English.lproj/preferences.nib",
            @"Credits.rtfd", @"General.png", @"AutoCorrect.png", @"Credits.png"];
        for (NSString *resource in resources) {
            NSString *path = [[bundle resourcePath] stringByAppendingPathComponent:resource];
            require([[NSFileManager defaultManager] fileExistsAtPath:path], resource);
        }
        require([NSDictionary dictionaryWithContentsOfFile:
            [bundle pathForResource:@"preferences" ofType:@"plist"]] != nil, @"preferences plist loads");
        puts("PASS packaged resources exist and preferences plist loads");

        NSError *error = nil;
        NSData *json = [NSData dataWithContentsOfFile:[bundle pathForResource:@"transliteration" ofType:@"json"]];
        require(json != nil, @"fixtures exist");
        NSArray *fixtures = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
        require([fixtures isKindOfClass:[NSArray class]] && [fixtures count] > 0 && error == nil, @"fixtures decode");
        for (NSDictionary *fixture in fixtures) {
            NSString *input = [fixture objectForKey:@"input"];
            NSString *expected = [fixture objectForKey:@"output"];
            NSString *actual = [[AvroParser sharedInstance] parse:input];
            // NSData comparison deliberately avoids Unicode normalization.
            require([[actual dataUsingEncoding:NSUTF8StringEncoding] isEqualToData:
                [expected dataUsingEncoding:NSUTF8StringEncoding]],
                [NSString stringWithFormat:@"parser %@: expected %@, got %@", input, expected, actual]);
        }
        printf("PASS %lu exact UTF-8 parser fixtures\n", (unsigned long)[fixtures count]);

        sqlite3 *db = NULL;
        NSString *dbPath = [bundle pathForResource:@"database" ofType:@"db3"];
        require(sqlite3_open_v2([dbPath fileSystemRepresentation], &db, SQLITE_OPEN_READONLY, NULL) == SQLITE_OK,
            @"dictionary opens read-only");
        sqlite3_stmt *statement = NULL;
        require(sqlite3_prepare_v2(db, "PRAGMA integrity_check", -1, &statement, NULL) == SQLITE_OK,
            @"dictionary integrity query prepares");
        require(sqlite3_step(statement) == SQLITE_ROW &&
            strcmp((const char *)sqlite3_column_text(statement, 0), "ok") == 0, @"dictionary integrity");
        sqlite3_finalize(statement);
        sqlite3_close(db);
        puts("PASS packaged SQLite dictionary integrity");

        NSString *regex = [[RegexParser sharedInstance] parse:@"ami"];
        require([regex length] > 0 && [@"আমি" isMatchedByRegex:regex], @"ICU regex matches ami");
        require([[[Database sharedInstance] find:@"ami"] containsObject:@"আমি"], @"dictionary returns ami");
        puts("PASS regex rules, system ICU and dictionary lookup");

        AutoCorrect *autocorrect = [AutoCorrect sharedInstance];
        require([[autocorrect autoCorrectEntries] count] > 0, @"autocorrect dictionary loads");
        require([[autocorrect find:@"#-o"] isEqualToString:@"#-o"], @"existing emoticon remains unchanged");
        puts("PASS autocorrect dictionary and emoticon passthrough");

        NSData *distanceData = [NSData dataWithContentsOfFile:[bundle pathForResource:@"distance" ofType:@"json"]];
        require(distanceData != nil, @"distance fixtures exist");
        NSDictionary *distanceFixtures = [NSJSONSerialization JSONObjectWithData:distanceData options:0 error:&error];
        require([distanceFixtures isKindOfClass:[NSDictionary class]] && error == nil, @"distance fixtures decode");
        NSArray *pairs = [distanceFixtures objectForKey:@"pairs"];
        require([pairs count] > 0, @"distance fixtures contain pairs");
        for (NSArray *pair in pairs) {
            require([[pair objectAtIndex:0] computeLevenshteinDistanceWithString:[pair objectAtIndex:1]] ==
                [[pair objectAtIndex:2] intValue], [NSString stringWithFormat:@"distance pair %@", pair]);
        }
        require([@"ami" computeLevenshteinDistanceWithString:nil] == -1, @"nil input retains empty-input result");
        NSArray *rankings = [distanceFixtures objectForKey:@"rankings"];
        require([rankings count] > 0, @"ranking fixtures exist");
        for (NSDictionary *ranking in rankings) {
            NSString *term = [ranking objectForKey:@"term"];
            NSString *parsed = [[AvroParser sharedInstance] parse:term];
            NSArray *candidates = [[Database sharedInstance] find:term];
            require([parsed isEqualToString:[ranking objectForKey:@"parsed"]] &&
                [candidates isEqualToArray:[ranking objectForKey:@"candidates"]], @"ranking inputs remain unchanged");
            NSMutableArray *distances = [NSMutableArray array];
            for (NSString *candidate in candidates) {
                [distances addObject:@([parsed computeLevenshteinDistanceWithString:candidate])];
            }
            require([distances isEqualToArray:[ranking objectForKey:@"distances"]], @"candidate distances remain unchanged");
            NSArray *ordered = [candidates sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
                int left = [parsed computeLevenshteinDistanceWithString:a];
                int right = [parsed computeLevenshteinDistanceWithString:b];
                return left < right ? NSOrderedAscending : (left > right ? NSOrderedDescending : NSOrderedSame);
            }];
            require([ordered isEqualToArray:[ranking objectForKey:@"ordered"]], @"dictionary suggestion order remains unchanged");
        }
        printf("PASS %lu original distance pairs, nil input and %lu dictionary rankings\n",
            (unsigned long)[pairs count], (unsigned long)[rankings count]);
    }
    return 0;
}
