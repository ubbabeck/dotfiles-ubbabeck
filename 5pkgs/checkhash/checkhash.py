#!/usr/bin/env python3

import hashlib
import sys


def main() -> None:
    if len(sys.argv) != 3:
        print("usage: checkhash <expected hash> <data to check>")
        sys.exit(1)

    data = sys.argv[2].encode()
    hash = hashlib.sha256(data).hexdigest()

    if hash == sys.argv[1]:
        print("✅ hash matched")
        sys.exit(0)
    else:
        print("❌ hash did not match")
        sys.exit(1)


if __name__ == "__main__":
    main()
