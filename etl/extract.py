from pathlib import Path
import pandas as pd
import os


RAW_DIR = Path(
    os.getenv(
        "RAW_DATA_DIR",
        str(Path(__file__).resolve().parent.parent / "data" / "raw"),
    )
)


def extract_csv(filename):
    path = RAW_DIR / filename

    if not path.exists():
        raise FileNotFoundError(f"File not found: {path}")

    df = pd.read_csv(path)

    print(f"Extracted {filename}: {len(df)} rows")

    return df