#import "Kiwi.h"
#import "NSDate+Escort.h"
#import "FakeDateUtil.h"
#import "NSDate+AZDateBuilder.h"

SPEC_BEGIN(EscortComparingSpec)

    registerMatchers(@"AZ");// NSDate Custom Matcher
    describe(@"-isEqualToDateIgnoringTime", ^{
        NSDate *currentDate = [NSDate date];
        beforeEach(^{
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when same the date", ^{
            it(@"should be true", ^{
                BOOL isMatch = [currentDate isEqualToDateIgnoringTime:currentDate];
                [[theValue(isMatch) should] beYes];
            });

        });
        context(@"when target is today", ^{
            it(@"should be true", ^{
                NSDate *beginOfDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.hour : @0,
                    AZ_DateUnit.minute : @0,
                    AZ_DateUnit.second : @0,
                }];
                NSDate *endOfDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.hour : @23,
                    AZ_DateUnit.minute : @59,
                    AZ_DateUnit.second : @59,
                }];
                BOOL isMatch_begin = [beginOfDate isEqualToDateIgnoringTime:currentDate];
                BOOL isMatch_end = [endOfDate isEqualToDateIgnoringTime:currentDate];
                [[theValue(isMatch_begin) should] beYes];
                [[theValue(isMatch_end) should] beYes];
            });
        });
        context(@"when target is a later day", ^{
            it(@"should be false", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] + 1),
                    AZ_DateUnit.hour : @0,
                    AZ_DateUnit.minute : @0,
                    AZ_DateUnit.second : @0,
                }];
                BOOL isMatch = [laterDate isEqualToDateIgnoringTime:currentDate];
                [[theValue(isMatch) should] beNo];
            });
        });
        context(@"when target is a earler day", ^{
            it(@"should be false", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] - 1),
                    AZ_DateUnit.hour : @23,
                    AZ_DateUnit.minute : @59,
                    AZ_DateUnit.second : @59,
                }];
                BOOL isMatch = [laterDate isEqualToDateIgnoringTime:currentDate];
                [[theValue(isMatch) should] beNo];
            });
        });
        context(@"when target is previous era", ^{
            __block NSDate *currentDate;
            __block NSDate *previousEraDate;
            beforeEach(^{
                currentDate = [NSDate dateByUnit:@{
                        AZ_DateUnit.year : @2014,
                        AZ_DateUnit.month : @5,
                        AZ_DateUnit.day : @19,
                }];
                previousEraDate = [NSDate dateByUnit:@{
                        AZ_DateUnit.year : @1951,
                        AZ_DateUnit.month : @5,
                        AZ_DateUnit.day : @19,
                }];

                NSCalendar *jaCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSJapaneseCalendar];
                [NSDate stub:@selector(AZ_currentCalendar) andReturn:jaCalendar];
            });
            it(@"should be false", ^{
                BOOL isMatch = [previousEraDate isEqualToDateIgnoringTime:currentDate];
                [[theValue(isMatch) should] beNo];
            });
        });
    });
    describe(@"-isToday", ^{
        NSDate *currentDate = [NSDate date];
        beforeEach(^{
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when suject is same date", ^{
            it(@"should be true", ^{
                BOOL match = [currentDate isToday];
                [[theValue(match) should] beYes];
            });
        });
        context(@"when subject is a later day", ^{
            it(@"should be false", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] + 1),
                    AZ_DateUnit.hour : @0,
                    AZ_DateUnit.minute : @0,
                    AZ_DateUnit.second : @0,
                }];
                BOOL isMatch = [laterDate isToday];
                [[theValue(isMatch) should] beNo];
            });
        });
        context(@"when subject is a earler day", ^{
            it(@"should be false", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] - 1),
                    AZ_DateUnit.hour : @23,
                    AZ_DateUnit.minute : @59,
                    AZ_DateUnit.second : @59,
                }];
                BOOL isMatch = [laterDate isToday];
                [[theValue(isMatch) should] beNo];
            });
        });
    });
    describe(@"-isTomorrow", ^{
        NSDate *currentDate = [NSDate date];
        beforeEach(^{
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when suject is same date", ^{
            it(@"should be false", ^{
                BOOL match = [currentDate isTomorrow];
                [[theValue(match) should] beNo];
            });
        });
        context(@"when subject is a tomorrow", ^{
            it(@"should be true", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] + 1),
                    AZ_DateUnit.hour : @0,
                    AZ_DateUnit.minute : @0,
                    AZ_DateUnit.second : @0,
                }];
                BOOL isMatch = [laterDate isTomorrow];
                [[theValue(isMatch) should] beYes];
            });
        });
        context(@"when subject is 2day later", ^{
            it(@"should be false", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] + 2),
                    AZ_DateUnit.hour : @0,
                    AZ_DateUnit.minute : @0,
                    AZ_DateUnit.second : @0,
                }];
                BOOL isMatch = [laterDate isTomorrow];
                [[theValue(isMatch) should] beNo];
            });
        });
    });
    describe(@"-isYesterday", ^{
        NSDate *currentDate = [NSDate date];
        beforeEach(^{
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when suject is same date", ^{
            it(@"should be false", ^{
                BOOL match = [currentDate isYesterday];
                [[theValue(match) should] beNo];
            });
        });
        context(@"when subject is a yesterday", ^{
            it(@"should be true", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] - 1),
                    AZ_DateUnit.hour : @0,
                    AZ_DateUnit.minute : @0,
                    AZ_DateUnit.second : @0,
                }];
                BOOL isMatch = [laterDate isYesterday];
                [[theValue(isMatch) should] beYes];
            });
        });
        context(@"when subject is 2day ago", ^{
            it(@"should be false", ^{
                NSDate *laterDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.day : @([currentDate day] - 2),
                    AZ_DateUnit.hour : @0,
                    AZ_DateUnit.minute : @0,
                    AZ_DateUnit.second : @0,
                }];
                BOOL isMatch = [laterDate isYesterday];
                [[theValue(isMatch) should] beNo];
            });
        });
    });
    describe(@"-isSameWeekAsDate", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"same week", ^{
            it(@"should be true", ^{
                BOOL match = [currentDate isSameWeekAsDate:currentDate];
                [[theValue(match) should] beYes];
            });
        });
        context(@"withink this week", ^{
            context(@"firstOfWeek", ^{
                it(@"should be true", ^{
                    // weekday 1...7
                    NSDate *firstOfWeek = [currentDate dateByUnit:@{
                        AZ_DateUnit.day : @([currentDate firstDayOfWeekday])
                    }];
                    BOOL match_first = [firstOfWeek isSameWeekAsDate:currentDate];
                    [[theValue(match_first) should] beYes];
                });
            });
            context(@"endOfWeek", ^{
                it(@"should be true", ^{
                    NSDate *lastOfWeek = [currentDate dateByUnit:@{
                        AZ_DateUnit.day : @([currentDate lastDayOfWeekday])
                    }];
                    BOOL match_last = [lastOfWeek isSameWeekAsDate:currentDate];
                    [[theValue(match_last) should] beYes];
                });
            });
        });
        context(@"when same the week, but difference year", ^{
            it(@"should be false", ^{
                NSDate *nextYearDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.year : @([currentDate year] + 1),
                }];
                BOOL match = [nextYearDate isSameWeekAsDate:currentDate];
                [[theValue(match) should] beNo];
            });
        });
        context(@"next week", ^{
            __block NSDate *nextWeekDate;
            beforeEach(^{
                nextWeekDate = [currentDate dateByAddingDays:DAYS_IN_WEEK];
            });
            it(@"should be false", ^{
                BOOL match = [nextWeekDate isSameWeekAsDate:currentDate];
                [[theValue(match) should] beNo];
            });
        });
        context(@"last week", ^{
            __block NSDate *prevWeekDate;
            beforeEach(^{
                prevWeekDate = [currentDate dateBySubtractingDays:DAYS_IN_WEEK];
            });
            it(@"should be false", ^{
                BOOL match = [prevWeekDate isSameWeekAsDate:currentDate];
                [[theValue(match) should] beNo];
            });
        });
    });
    describe(@"-isThisWeek", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"same week", ^{
            it(@"should be true", ^{
                BOOL match = [currentDate isThisWeek];
                [[theValue(match) should] beYes];
            });
        });
        context(@"within this week", ^{
            context(@"firstOfWeek", ^{
                it(@"should be true", ^{
                    // weekday 1...7
                    NSDate *firstOfWeek = [currentDate dateByUnit:@{
                        AZ_DateUnit.day : @([currentDate firstDayOfWeekday])
                    }];
                    BOOL match_first = [firstOfWeek isThisWeek];
                    [[theValue(match_first) should] beYes];
                });
            });
            context(@"endOfWeek", ^{
                it(@"should be true", ^{
                    NSDate *lastOfWeek = [currentDate dateByUnit:@{
                        AZ_DateUnit.day : @([currentDate lastDayOfWeekday])
                    }];
                    BOOL match_last = [lastOfWeek isThisWeek];
                    [[theValue(match_last) should] beYes];
                });
            });
        });
        context(@"next week", ^{
            __block NSDate *nextWeekDate;
            beforeEach(^{
                nextWeekDate = [currentDate dateByAddingDays:DAYS_IN_WEEK];
            });
            it(@"should be false", ^{
                BOOL match = [nextWeekDate isThisWeek];
                [[theValue(match) should] beNo];
            });
        });
        context(@"last week", ^{
            __block NSDate *prevWeekDate;
            beforeEach(^{
                prevWeekDate = [currentDate dateBySubtractingDays:DAYS_IN_WEEK];
            });
            it(@"should be false", ^{
                BOOL match = [prevWeekDate isThisWeek];
                [[theValue(match) should] beNo];
            });
        });
    });
    describe(@"-isNextWeek", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"within this week", ^{
            context(@"at endOfWeek", ^{
                it(@"should be false", ^{
                    NSDate *endOfWeek = [currentDate dateByUnit:@{
                        AZ_DateUnit.day : @([currentDate lastDayOfWeekday])
                    }];
                    BOOL match = [endOfWeek isNextWeek];
                    [[theValue(match) should] beNo];
                });
            });
        });
        context(@"next week", ^{
            __block NSDate *nextWeekDate;
            beforeEach(^{
                nextWeekDate = [currentDate dateByAddingDays:DAYS_IN_WEEK];
            });
            it(@"should be true", ^{
                BOOL match = [nextWeekDate isNextWeek];
                [[theValue(match) should] beYes];
            });
        });
        context(@"two weeks later", ^{
            __block NSDate *nextWeekDate;
            beforeEach(^{
                nextWeekDate = [currentDate dateByAddingDays:DAYS_IN_WEEK * 2];
            });
            it(@"should be false", ^{
                BOOL match = [nextWeekDate isNextWeek];
                [[theValue(match) should] beNo];
            });
        });
    });
    describe(@"-isLastWeek", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @9,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"within this week", ^{
            context(@"at startOfWeek", ^{
                it(@"should be false", ^{
                    NSDate *lastOfWeek = [currentDate dateByUnit:@{
                        AZ_DateUnit.day : @([currentDate firstDayOfWeekday])
                    }];
                    BOOL match = [lastOfWeek isLastWeek];
                    [[theValue(match) should] beNo];
                });
            });
        });
        context(@"when last week", ^{
            __block NSDate *prevWeekDate;
            beforeEach(^{
                prevWeekDate = [currentDate dateBySubtractingDays:DAYS_IN_WEEK];
            });
            it(@"should be true", ^{
                BOOL match = [prevWeekDate isLastWeek];
                [[theValue(match) should] beYes];
            });
        });
        context(@"when two weeks ago", ^{
            __block NSDate *prevWeekDate;
            beforeEach(^{
                prevWeekDate = [currentDate dateBySubtractingDays:DAYS_IN_WEEK * 2];
            });
            it(@"should be false", ^{
                BOOL match = [prevWeekDate isLastWeek];
                [[theValue(match) should] beNo];
            });
        });
    });
    describe(@"-isSameMonthAsDate", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"within this month", ^{
            context(@"at start of month", ^{
                it(@"should be yes", ^{
                    NSDate *startOfMonth = [currentDate dateAtStartOfMonth];
                    BOOL match = [currentDate isSameMonthAsDate:startOfMonth];
                    [[theValue(match) should] beYes];
                });
            });
            context(@"at end of month", ^{
                it(@"should be yes", ^{
                    NSDate *endOfMonth = [currentDate dateAtEndOfMonth];
                    BOOL match = [currentDate isSameMonthAsDate:endOfMonth];
                    [[theValue(match) should] beYes];
                });
            });
        });
        context(@"next month", ^{
            __block NSDate *nextMonth;
            beforeEach(^{
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *oneMonthComponents = [[NSDateComponents alloc] init];
                oneMonthComponents.month = 1;
                nextMonth = [calendar dateByAddingComponents:oneMonthComponents toDate:currentDate options:0];
            });
            it(@"should be false", ^{
                BOOL match = [currentDate isSameMonthAsDate:nextMonth];
                [[theValue(match) should] beNo];
            });
        });
        context(@"last month", ^{
            __block NSDate *lastMonth;
            beforeEach(^{
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *oneMonthComponents = [[NSDateComponents alloc] init];
                oneMonthComponents.month = -1;
                lastMonth = [calendar dateByAddingComponents:oneMonthComponents toDate:currentDate options:0];
            });
            it(@"should be false", ^{
                BOOL match = [currentDate isSameMonthAsDate:lastMonth];
                [[theValue(match) should] beNo];
            });
        });
        context(@"next year", ^{
            __block NSDate *nextYear;
            beforeEach(^{
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *oneMonthComponents = [[NSDateComponents alloc] init];
                oneMonthComponents.year = 1;
                nextYear = [calendar dateByAddingComponents:oneMonthComponents toDate:currentDate options:0];
            });
            it(@"should be false", ^{
                BOOL match = [currentDate isSameMonthAsDate:nextYear];
                [[theValue(match) should] beNo];
            });
        });
    });
    describe(@"-isThisMonth", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when sameMonth as Date", ^{
            it(@"should be true", ^{
                BOOL match = [currentDate isThisMonth];
                [[theValue(match) should] beYes];
            });
        });
    });
    describe(@"-isSameYearAsDate", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"within this year", ^{
            context(@"at start of year", ^{
                __block NSDate *startOfYear;
                beforeEach(^{
                    startOfYear = [currentDate dateAtStartOfYear];
                });
                it(@"should be yes", ^{
                    BOOL match = [currentDate isSameYearAsDate:startOfYear];
                    [[theValue(match) should] beYes];
                });
            });
            context(@"at end of year", ^{
                __block NSDate *endOfYear;
                beforeEach(^{
                    endOfYear = [currentDate dateAtEndOfYear];
                });
                it(@"should be yes", ^{
                    BOOL match = [currentDate isSameYearAsDate:endOfYear];
                    [[theValue(match) should] beYes];
                });
            });
        });
        context(@"last year", ^{
            __block NSDate *lastYear;
            beforeEach(^{
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *oneMonthComponents = [[NSDateComponents alloc] init];
                oneMonthComponents.year = -1;
                lastYear = [calendar dateByAddingComponents:oneMonthComponents toDate:currentDate options:0];
            });
            it(@"should be false", ^{
                BOOL match = [currentDate isSameYearAsDate:lastYear];
                [[theValue(match) should] beNo];
            });
        });
        context(@"next year", ^{
            __block NSDate *nextYear;
            beforeEach(^{
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *oneMonthComponents = [[NSDateComponents alloc] init];
                oneMonthComponents.year = 1;
                nextYear = [calendar dateByAddingComponents:oneMonthComponents toDate:currentDate options:0];
            });
            it(@"should be false", ^{
                BOOL match = [currentDate isSameYearAsDate:nextYear];
                [[theValue(match) should] beNo];
            });
        });
    });
    describe(@"-isThisYear", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"within this year", ^{
            it(@"should be true", ^{
                BOOL match = [currentDate isThisYear];
                [[theValue(match) should] beYes];
            });
        });
        context(@"other year", ^{
            __block NSDate *otherYearDate;
            beforeEach(^{
                NSInteger currentYear = [currentDate year];
                otherYearDate = [currentDate dateByUnit:@{
                    AZ_DateUnit.year : @(currentYear + 10)
                }];
            });
            it(@"should be false", ^{
                BOOL match = [otherYearDate isThisYear];
                [[theValue(match) should] beNo];
            });
        });
    });
    describe(@"-isNextYear", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"this week", ^{
            it(@"should be false", ^{
                BOOL match = [currentDate isNextYear];
                [[theValue(match) should] beNo];
            });
        });
        context(@"next year", ^{
            __block NSDate *nextYear;
            beforeEach(^{
                NSInteger currentYear = [currentDate gregorianYear];
                nextYear = [currentDate dateByUnit:@{
                    AZ_DateUnit.year : @(currentYear + 1)
                }];
            });
            it(@"should be true", ^{
                BOOL match = [nextYear isNextYear];
                [[theValue(match) should] beYes];
            });
        });
        context(@"two years later", ^{
            __block NSDate *twoYearsLater;
            beforeEach(^{
                NSInteger currentYear = [currentDate gregorianYear];
                twoYearsLater = [currentDate dateByUnit:@{
                    AZ_DateUnit.year : @(currentYear + 2)
                }];
            });
            it(@"should be false", ^{
                BOOL match = [twoYearsLater isNextYear];
                [[theValue(match) should] beNo];
            });
        });
    });
    describe(@"-isLastYear", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"this week", ^{
            it(@"should be false", ^{
                BOOL match = [currentDate isLastYear];
                [[theValue(match) should] beNo];
            });
        });
        context(@"last year", ^{
            __block NSDate *lastYear;
            beforeEach(^{
                NSInteger currentYear = [currentDate gregorianYear];
                lastYear = [currentDate dateByUnit:@{
                    AZ_DateUnit.year : @(currentYear - 1)
                }];
            });
            it(@"should be true", ^{
                BOOL match = [lastYear isLastYear];
                [[theValue(match) should] beYes];
            });
        });
        context(@"two years ago", ^{
            __block NSDate *twoYearsAgo;
            beforeEach(^{
                NSInteger currentYear = [currentDate gregorianYear];
                twoYearsAgo = [currentDate dateByUnit:@{
                    AZ_DateUnit.year : @(currentYear - 2)
                }];
            });
            it(@"should be false", ^{
                BOOL match = [twoYearsAgo isLastYear];
                [[theValue(match) should] beNo];
            });
        });
    });
    describe(@"-isEarlierThanDate", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
                AZ_DateUnit.hour : @10,
                AZ_DateUnit.minute : @10,
                AZ_DateUnit.second : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when same time", ^{
            it(@"should be false", ^{
                BOOL match = [currentDate isEarlierThanDate:currentDate];
                [[theValue(match) should] beNo];
            });
        });
        context(@"when earlier date", ^{
            __block NSDate *earlierDate;
            beforeEach(^{
                earlierDate = [currentDate dateByAddingTimeInterval:-1];
            });
            it(@"should be true", ^{
                BOOL match = [earlierDate isEarlierThanDate:currentDate];
                [[theValue(match) should] beYes];
            });
        });
        context(@"when later date", ^{
            __block NSDate *laterDate;
            beforeEach(^{
                laterDate = [currentDate dateByAddingTimeInterval:1];
            });
            it(@"should be false", ^{
                BOOL match = [laterDate isEarlierThanDate:currentDate];
                [[theValue(match) should] beNo];
            });
        });
    });
    describe(@"-isLaterThanDate", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
                AZ_DateUnit.hour : @10,
                AZ_DateUnit.minute : @10,
                AZ_DateUnit.second : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when same time", ^{
            it(@"should be false", ^{
                BOOL match = [currentDate isLaterThanDate:currentDate];
                [[theValue(match) should] beNo];
            });
        });
        context(@"when earlier date", ^{
            __block NSDate *earlierDate;
            beforeEach(^{
                earlierDate = [currentDate dateByAddingTimeInterval:-1];
            });
            it(@"should be false", ^{
                BOOL match = [earlierDate isLaterThanDate:currentDate];
                [[theValue(match) should] beNo];
            });
        });
        context(@"when later date", ^{
            __block NSDate *laterDate;
            beforeEach(^{
                laterDate = [currentDate dateByAddingTimeInterval:1];
            });
            it(@"should be true", ^{
                BOOL match = [laterDate isLaterThanDate:currentDate];
                [[theValue(match) should] beYes];
            });
        });
    });
    describe(@"-isEarlierThanOrEqualDate", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
                AZ_DateUnit.hour : @10,
                AZ_DateUnit.minute : @10,
                AZ_DateUnit.second : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when same time", ^{
            it(@"should be false", ^{
                BOOL match = [currentDate isEarlierThanOrEqualDate:currentDate];
                [[theValue(match) should] beYes];
            });
        });
        context(@"when earlier date", ^{
            __block NSDate *earlierDate;
            beforeEach(^{
                earlierDate = [currentDate dateByAddingTimeInterval:-1];
            });
            it(@"should be true", ^{
                BOOL match = [earlierDate isEarlierThanOrEqualDate:currentDate];
                [[theValue(match) should] beYes];
            });
        });
        context(@"when later date", ^{
            __block NSDate *laterDate;
            beforeEach(^{
                laterDate = [currentDate dateByAddingTimeInterval:1];
            });
            it(@"should be false", ^{
                BOOL match = [laterDate isEarlierThanOrEqualDate:currentDate];
                [[theValue(match) should] beNo];
            });
        });
    });
    describe(@"-isLaterThanOrEqualDate", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
                AZ_DateUnit.hour : @10,
                AZ_DateUnit.minute : @10,
                AZ_DateUnit.second : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when same time", ^{
            it(@"should be true", ^{
                BOOL match = [currentDate isLaterThanOrEqualDate:currentDate];
                [[theValue(match) should] beYes];
            });
        });
        context(@"when earlier date", ^{
            __block NSDate *earlierDate;
            beforeEach(^{
                earlierDate = [currentDate dateByAddingTimeInterval:-1];
            });
            it(@"should be false", ^{
                BOOL match = [earlierDate isLaterThanOrEqualDate:currentDate];
                [[theValue(match) should] beNo];
            });
        });
        context(@"when later date", ^{
            __block NSDate *laterDate;
            beforeEach(^{
                laterDate = [currentDate dateByAddingTimeInterval:1];
            });
            it(@"should be true", ^{
                BOOL match = [laterDate isLaterThanOrEqualDate:currentDate];
                [[theValue(match) should] beYes];
            });
        });
    });
    describe(@"-isInPast", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
                AZ_DateUnit.hour : @10,
                AZ_DateUnit.minute : @10,
                AZ_DateUnit.second : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when same time", ^{
            it(@"should be false", ^{
                BOOL match = [currentDate isInPast];
                [[theValue(match) should] beNo];
            });
        });
        context(@"when earlier date", ^{
            __block NSDate *earlierDate;
            beforeEach(^{
                earlierDate = [currentDate dateByAddingTimeInterval:-1];
            });
            it(@"should be true", ^{
                BOOL match = [earlierDate isInPast];
                [[theValue(match) should] beYes];
            });
        });
    });

    describe(@"-isInFuture", ^{
        __block NSDate *currentDate;
        beforeEach(^{
            currentDate = [NSDate dateByUnit:@{
                AZ_DateUnit.year : @2010,
                AZ_DateUnit.month : @10,
                AZ_DateUnit.day : @10,
                AZ_DateUnit.hour : @10,
                AZ_DateUnit.minute : @10,
                AZ_DateUnit.second : @10,
            }];
            [FakeDateUtil stubCurrentDate:currentDate];
        });
        context(@"when same time", ^{
            it(@"should be false", ^{
                BOOL match = [currentDate isInFuture];
                [[theValue(match) should] beNo];
            });
        });
        context(@"when later date", ^{
            __block NSDate *laterDate;
            beforeEach(^{
                laterDate = [currentDate dateByAddingTimeInterval:1];
            });
            it(@"should be true", ^{
                BOOL match = [laterDate isInFuture];
                [[theValue(match) should] beYes];
            });
        });
    });
    SPEC_END
