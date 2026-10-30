#!/usr/bin/env bash
set -euo pipefail

echo "=== 1. Проверка синтаксиса YAML через yamllint ==="
yamllint -d "{extends: default, rules: {line-length: {max: 120}, document-start: disable}}" configs/majestic.yaml
echo "[OK] YAML синтаксис корректен!"

echo "=== 2. Проверка ключевых параметров 60 FPS для GK7205V300 ==="
python3 - << 'EOF'
import yaml

with open('configs/majestic.yaml', 'r') as f:
    cfg = yaml.safe_load(f)

v0 = cfg.get('video0', {})
assert v0.get('fps') == 60, f"Ошибка: fps={v0.get('fps')} (ожидалось 60)"
assert v0.get('size') == '1920x1080', f"Ошибка: size={v0.get('size')}"
assert v0.get('codec') in ['h264', 'h265'], f"Ошибка: codec={v0.get('codec')}"

isp = cfg.get('isp', {})
assert isp.get('lowDelay') is True, "Ошибка: isp.lowDelay должен быть True"
print("[OK] Параметры video0.fps=60, 1080p и isp.lowDelay=true успешно проверены!")
EOF

echo "=== 3. Проверка конфигурации сенсора IMX307 ==="
grep -q "Isp_FrameRate=60" configs/imx307.ini || (echo "Ошибка: отсутствует Isp_FrameRate=60" && exit 1)
echo "[OK] Конфигурация сенсора IMX307 валидна!"

echo "==============================================="
echo "✅ ВСЕ ТЕСТЫ В КОНТЕЙНЕРЕ ПРОЙДЕНЫ УСПЕШНО!"
echo "==============================================="
