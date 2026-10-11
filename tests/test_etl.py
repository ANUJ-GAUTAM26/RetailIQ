import unittest
from pathlib import Path
from tempfile import TemporaryDirectory
from unittest.mock import patch

from etl.extract import extract_csv


class TestExtractCSV(unittest.TestCase):

    def test_extract_csv_success(self):
        with TemporaryDirectory() as tmp:
            path = Path(tmp) / "sample.csv"
            path.write_text("id,name\n1,Anuj\n", encoding="utf-8")

            with patch("etl.extract.RAW_DIR", Path(tmp)):
                df = extract_csv("sample.csv")

            self.assertEqual(len(df), 1)
            self.assertEqual(list(df.columns), ["id", "name"])

    def test_missing_file_raises_error(self):
        with TemporaryDirectory() as tmp:
            with patch("etl.extract.RAW_DIR", Path(tmp)):
                with self.assertRaises(FileNotFoundError):
                    extract_csv("missing.csv")


if __name__ == "__main__":
    unittest.main()