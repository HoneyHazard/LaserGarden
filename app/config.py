import argparse
import os
import logging

def parse_arguments():
    parser = argparse.ArgumentParser(description="LaserGarden DMX Controller")
    parser.add_argument("--target-ip", type=str, default="192.168.7.99", help="IP address of the target Art-Net device")
    parser.add_argument("--preset", type=str, help="Path to the initial preset file to load")
    parser.add_argument("--qlc-workspace", type=str, help="Path to the QLC workspace file to import scenes")
    parser.add_argument('--ola002', action='store_true', help="Set ola002 to True")

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
    
    return args.target_ip, initial_preset, args.qlc_workspace
