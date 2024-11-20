# -*- coding: utf-8 -*-
from dataclasses import dataclass
import unittest
from gilded_rose import Item, GildedRose
@dataclass
class CaseOfTest:
    days: int
    quality: int
    expected_new_quality: int
    expected_new_days: int
class GildedRoseTest(unittest.TestCase):
    def composed_assert(self, item, test_cases):
        for tc in test_cases:
            print(f"{item=} {tc=}")
            items = [Item(item, tc.days, tc.quality)]
            gilded_rose = GildedRose(items)
            gilded_rose.update_quality()
            self.assertEqual(items[0].quality, tc.expected_new_quality)
            self.assertEqual(items[0].sell_in, tc.expected_new_days)
    def test_normal_decreases_quality(self):
        self.composed_assert("normal item", [
            CaseOfTest(days=20, quality=43, expected_new_quality=42, expected_new_days=19),
            CaseOfTest(days=9, quality=43, expected_new_quality=42, expected_new_days=8),
            CaseOfTest(days=0, quality=43, expected_new_quality=41, expected_new_days=-1), # FIXME
            CaseOfTest(days=0, quality=50, expected_new_quality=48, expected_new_days=-1), # FIXME
            CaseOfTest(days=2, quality=0, expected_new_quality=0, expected_new_days=1),
        ])
    def test_sulfuras_never_changes(self):
        self.composed_assert("Sulfuras, Hand of Ragnaros", [
            CaseOfTest(days=20, quality=43, expected_new_quality=43, expected_new_days=20),
            CaseOfTest(days=9, quality=43, expected_new_quality=43, expected_new_days=9),
            CaseOfTest(days=0, quality=43, expected_new_quality=43, expected_new_days=0),
            CaseOfTest(days=0, quality=50, expected_new_quality=50, expected_new_days=0),
        ])
    def test_aged_brie_increases_quality(self):
        self.composed_assert("Aged Brie", [
            CaseOfTest(days=20, quality=43, expected_new_quality=44, expected_new_days=19),
            CaseOfTest(days=9, quality=43, expected_new_quality=44, expected_new_days=8),
            CaseOfTest(days=0, quality=43, expected_new_quality=45, expected_new_days=-1), # FIXME
            CaseOfTest(days=0, quality=50, expected_new_quality=50, expected_new_days=-1),
        ])
    def test_backstage_passes_has_special_rules(self):
        self.composed_assert("Backstage passes to a TAFKAL80ETC concert", [
            CaseOfTest(days=20, quality=43, expected_new_quality=44, expected_new_days=19),
            CaseOfTest(days=9, quality=43, expected_new_quality=45, expected_new_days=8),
            CaseOfTest(days=4, quality=43, expected_new_quality=46, expected_new_days=3),
            CaseOfTest(days=0, quality=43, expected_new_quality=0, expected_new_days=-1),
        ])
if __name__ == '__main__':
    unittest.main()
