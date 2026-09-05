"""Regression tests for complete multiline NPC dialogue translation."""

import csv
import io
from pathlib import Path
import tempfile
import unittest

from extend_npc_dialogue_catalog import (
    append_greetings, merge_runtime_continuations, read_tsv,
)
from text_localization import read_field_overlay
from extend_legacy_text_catalog import import_classes, import_scrolls


def rows(text):
    return list(csv.reader(io.StringIO(text, newline=""), delimiter="\t"))


class MultilineNpcDialogueTests(unittest.TestCase):
    def test_greeting_continuations_complete_both_fields_and_owner(self):
        source = rows('#\tGreeting 1\tGreeting 2\tNotes\tOwner\n'
                      '1\t"First greeting"\tHave you spoken with Dadeross?\n'
                      "What are we to do now?\t\tS'ton\t\n"
                      '2\tFirst line\nSecond line\tSecond greeting\nLast line\t\tDadeross\t\n')
        merged = merge_runtime_continuations(source, None)
        self.assertEqual(len(merged), 3)
        self.assertEqual(merged[1][2], 'Have you spoken with Dadeross?\nWhat are we to do now?')
        self.assertEqual(merged[1][4], "S'ton")
        self.assertEqual(merged[2][1:5], ['First line\nSecond line', 'Second greeting\nLast line', '', 'Dadeross'])
        self.assertEqual(merge_runtime_continuations(merged, None), merged)

    def test_quoted_newlines_and_topic_metadata_remain_intact(self):
        source = rows('#\tText\tNotes\tOwner\n1\t"First\nSecond"\tnote\towner\n'
                      'Third\tignored continuation metadata\n2\tNext\t\towner2\n')
        merged = merge_runtime_continuations(source, 1)
        self.assertEqual(merged[1], ['1', 'First\nSecond\nThird', 'note', 'owner'])
        self.assertEqual(merged[2], ['2', 'Next', '', 'owner2'])

    def test_translation_source_reads_unquoted_and_quoted_continuations(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'overlay.txt'
            path.write_text('Table\tId\tField\tNew text\nNPCGreet\t1\t1\t첫 문장\n'
                            '다음 문장\n\n마지막 문장\n\t2\t1\t"둘째 인사\n둘째 줄"\n',
                            encoding='cp949', newline='\n')
            translations, encoding = read_field_overlay(path)
            self.assertEqual(encoding, 'cp949')
            self.assertEqual(translations[(1, '1')], '첫 문장\n다음 문장\n\n마지막 문장')
            self.assertEqual(translations[(2, '1')], '둘째 인사\n둘째 줄')

    def test_duplicate_or_orphan_translation_records_fail(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'overlay.txt'
            for body in ('orphan\n', 'NPCGreet\t1\t1\t첫 줄\n\t1\t1\t중복\n'):
                path.write_text('Table\tId\tField\tNew text\n' + body, encoding='utf-8')
                with self.assertRaises(ValueError):
                    read_field_overlay(path)

    def test_scroll_and_class_import_keep_translation_paragraphs(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            tables = root / 'assets_dev/engine/data_tables/english'
            tables.mkdir(parents=True)
            (tables / 'scroll.txt').write_text('Item#\tText\n700\t"First\nLast"\n', encoding='utf-8')
            (tables / 'class.txt').write_text('Class name\tDescription\tClass kind\nKnight\tDescription\tKnight\n',
                                            encoding='utf-8')
            translations = root / 'mmmerge/Data/Text localization'
            translations.mkdir(parents=True)
            for filename, value in (('KO_MessageScrolls.txt', '두루마리 첫 줄\n두루마리 끝 줄'),
                                    ('KO_ClassNames.txt', '기사'),
                                    ('KO_ClassDescriptions.txt', '직업 설명 첫 줄\n직업 설명 끝 줄')):
                (translations / filename).write_text('Table\tId\tField\tNew text\nTable\t0\t\t' + value + '\n',
                                                     encoding='utf-8')
            scroll_entries, _ = import_scrolls(root, root / 'mmmerge', root / 'overlay')
            class_entries, _ = import_classes(root, root / 'mmmerge', root / 'overlay')
            self.assertEqual(scroll_entries[0]['translation'], '두루마리 첫 줄\n두루마리 끝 줄')
            self.assertEqual(class_entries[1]['translation'], '직업 설명 첫 줄\n직업 설명 끝 줄')
            for filename, column, expected in (
                ('scroll.txt', 1, scroll_entries[0]['translation']),
                ('class.txt', 1, class_entries[1]['translation']),
            ):
                output, _ = read_tsv(root / 'overlay/data_tables/english' / filename, ('utf-8',))
                self.assertEqual(output[1][column], expected)

    def test_catalog_and_runtime_output_contain_the_same_complete_greetings(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / 'assets_dev/engine/data_tables/npc_greet.txt'
            source.parent.mkdir(parents=True)
            source.write_text('#\tGreeting 1\tGreeting 2\tNotes\tOwner\n'
                              "1\tHello\tHave you spoken with Dadeross?\nWhat are we to do now?\t\tS'ton\t\n",
                              encoding='utf-8')
            translations = root / 'mmmerge/Data/Text localization'
            translations.mkdir(parents=True)
            for number, field, text in ((1, 0, '안녕하세요'), (2, 1, '다데로스와 이야기해 보셨습니까?\n이제 어떻게 해야 합니까?')):
                (translations / f'KO_NPCGreet{number}.txt').write_text(
                    f'Table\tId\tField\tNew text\nNPCGreet\t1\t{field}\t{text}\n', encoding='utf-8')
            entries, stats = append_greetings(root, root / 'mmmerge', root / 'overlay')
            output, _ = read_tsv(root / 'overlay/data_tables/npc_greet.txt', ('utf-8',))
            self.assertEqual(len(entries), 2)
            self.assertEqual(stats['translated'], 2)
            self.assertIn('What are we to do now?', entries[1]['source'])
            self.assertEqual(output[1][2], entries[1]['translation'])
            self.assertNotIn('What are we to do now?', output[1][2])
            self.assertEqual(output[1][4], "S'ton")
            self.assertEqual(len(output), 2)


if __name__ == '__main__':
    unittest.main()
