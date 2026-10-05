// SPDX-License-Identifier: MPL-1.1
// Copyright (c) 2026 AkilTipu.
// Community implementation; see MODIFICATIONS.md and LICENSES/MPL-1.1.txt.

#import <Foundation/Foundation.h>

@interface NSString (Levenshtein)

// Preserve the existing API, UTF-16 comparison and -1 for empty inputs.
- (int)computeLevenshteinDistanceWithString:(NSString *)string;

@end
