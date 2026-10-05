// SPDX-License-Identifier: MPL-1.1
// Copyright (c) 2026 AkilTipu.
// Independently written community implementation of unit-cost edit distance.
// See MODIFICATIONS.md and LICENSES/MPL-1.1.txt.

#import "NSString+Levenshtein.h"
#include <limits.h>
#include <stdlib.h>

@implementation NSString (Levenshtein)

- (int)computeLevenshteinDistanceWithString:(NSString *)string {
    NSUInteger leftLength = [self length];
    NSUInteger rightLength = [string length];
    if (!leftLength || !rightLength || leftLength >= INT_MAX || rightLength >= INT_MAX) {
        return -1;
    }

    // Retain one row of the dynamic program and the previous diagonal value.
    int *row = malloc((rightLength + 1) * sizeof(*row));
    if (!row) return -1;
    for (NSUInteger column = 0; column <= rightLength; column++) row[column] = (int)column;

    for (NSUInteger line = 1; line <= leftLength; line++) {
        int diagonal = row[0];
        row[0] = (int)line;
        unichar character = [self characterAtIndex:line - 1];
        for (NSUInteger column = 1; column <= rightLength; column++) {
            int above = row[column];
            int substitution = diagonal + (character != [string characterAtIndex:column - 1]);
            int insertion = row[column - 1] + 1;
            int deletion = above + 1;
            row[column] = MIN(substitution, MIN(insertion, deletion));
            diagonal = above;
        }
    }

    int result = row[rightLength];
    free(row);
    return result;
}

@end
