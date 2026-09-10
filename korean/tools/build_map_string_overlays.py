#!/usr/bin/env python3
"""Run the KO_MapStrings generator without deleting unrelated world overlays.

The historical generator refreshes a world by calling ``shutil.rmtree`` on the
whole ``korean/overlay/worlds/<world>`` directory. Map translation generation
owns only ``events/maps``; subtitles and any future non-map overlay assets must
survive that refresh. The implementation is kept in
``build_map_string_overlays_core.py`` and this compatibility entry point narrows
that cleanup operation to the generated map subtree.
"""

from __future__ import annotations

import importlib.util
from pathlib import Path
import shutil as _stdlib_shutil

CORE_PATH = Path(__file__).with_name("build_map_string_overlays_core.py")
SPEC = importlib.util.spec_from_file_location("build_map_string_overlays_core", CORE_PATH)
assert SPEC is not None and SPEC.loader is not None
_core = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(_core)


class _ScopedShutil:
    """Proxy shutil while confining the core generator's world cleanup."""

    def __getattr__(self, name: str):
        return getattr(_stdlib_shutil, name)

    def rmtree(self, path, *args, **kwargs):
        candidate = Path(path)
        if candidate.name in _core.WORLDS and candidate.parent.name == "worlds":
            generated_maps = candidate / "events" / "maps"
            if generated_maps.exists():
                return _stdlib_shutil.rmtree(generated_maps, *args, **kwargs)
            return None
        return _stdlib_shutil.rmtree(path, *args, **kwargs)


# Preserve the public helper surface for existing tests/tools that import this
# module, while replacing only the cleanup dependency used by core.main().
for _name in dir(_core):
    if not _name.startswith("_") and _name not in {"main", "shutil"}:
        globals()[_name] = getattr(_core, _name)
_core.shutil = _ScopedShutil()
main = _core.main


if __name__ == "__main__":
    raise SystemExit(main())
