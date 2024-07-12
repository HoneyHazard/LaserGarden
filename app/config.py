import argparse
import os
import logging

def parse_arguments():
    parser = argparse.ArgumentParser(description="LaserGarden DMX Controller")
    parser.add_argument("--target-ip", type=str, default="192.168.7.99", help="IP address of the target Art-Net device")
    parser.add_argument("--preset", type=str, help="Path to the initial preset file to load")
    parser.add_argument("--qlc-workspace", type=str, help="Path to the QLC workspace file to import scenes")
    parser.add_argument('--ola002', action='store_true', help="Set ola002 to True to signify we are deadling with Olaalite OL-A002")
    parser.add_argument('--gla001', action='store_true', help="Set gla001 to True to signify we are deadling with Gruolin GL-A001/Olaalite OL-A003")
    parser.add_argument('--tooltip', action='store_true', help="Show tooltip sidebar on launch")
    args = parser.parse_args()
    
    initial_preset = None
    if args.preset:
        if os.path.isabs(args.preset):
            initial_preset = args.preset
        else:
            preset_path = os.path.join("presets", args.preset)
            if os.path.exists(preset_path):
                initial_preset = preset_path
            else:
                if os.path.exists(args.preset):
                    initial_preset = args.preset
                else:
                    logging.warning(f"Initial preset file {args.preset} not found in presets or current directory")
    
    return vars(args)
