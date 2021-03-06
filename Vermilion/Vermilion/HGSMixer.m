//
//  HGSMixer.m
//
//  Copyright (c) 2008 Google Inc. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are
//  met:
//
//    * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above
//  copyright notice, this list of conditions and the following disclaimer
//  in the documentation and/or other materials provided with the
//  distribution.
//    * Neither the name of Google Inc. nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
//  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
//  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
//  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "HGSMixer.h"

#import "HGSResult.h"
#import "HGSTokenizer.h"


inline NSInteger HGSMixerScoredResultSort(HGSScoredResult *resultA, 
                                          HGSScoredResult *resultB, 
                                          void* context) {
  NSInteger result = NSOrderedSame;
  HGSRankFlags rankFlagsA = [resultA rankFlags];
  HGSRankFlags rankFlagsB = [resultB rankFlags];
  BOOL shortcutA = rankFlagsA & eHGSShortcutRankFlag ? YES : NO;
  BOOL shortcutB = rankFlagsB & eHGSShortcutRankFlag ? YES : NO;
  if (shortcutA && !shortcutB) {
    result = NSOrderedAscending;
  } else if (!shortcutA && shortcutB) {
    result = NSOrderedDescending;
  } else {
    BOOL belowFoldA = rankFlagsA & eHGSBelowFoldRankFlag ? YES : NO;
    BOOL belowFoldB = rankFlagsB & eHGSBelowFoldRankFlag ? YES : NO;
    if (!belowFoldA && belowFoldB) {
      result = NSOrderedAscending;
    } else if (belowFoldA && !belowFoldB) {
      result = NSOrderedDescending;
    } else {
      CGFloat scoreA = [resultA score];
      CGFloat scoreB = [resultB score];
      if (scoreA > scoreB) {
        result = NSOrderedAscending;
      } else if (scoreA < scoreB) {
        result = NSOrderedDescending;
      } else {
        NSDate *lastUsedA 
          = [resultA valueForKey:kHGSObjectAttributeLastUsedDateKey];
        NSDate *lastUsedB 
          = [resultB valueForKey:kHGSObjectAttributeLastUsedDateKey];
        result = [lastUsedB compare:lastUsedA];
        if (result == NSOrderedSame) {
          NSString *normalizedA = [[resultA matchedTerm] tokenizedString];
          NSString *normalizedB = [[resultB matchedTerm] tokenizedString];
          result = [normalizedA compare:normalizedB];
          if (result == NSOrderedSame) {
            NSUInteger urlLengthA = [[resultA uri] length];
            NSUInteger urlLengthB = [[resultB uri] length];
            if (urlLengthA > urlLengthB) {
              result = NSOrderedDescending;
            } else if (urlLengthA < urlLengthB) {
              result = NSOrderedAscending;
            }
          }
        }
      }
    }
  }
  return result;
}
