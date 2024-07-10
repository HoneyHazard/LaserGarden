#!/usr/bin/python3

# existing modules
import sys
import os
import json
import signal
import argparse
import logging
from PySide6.QtCore import QUrl, QObject, Signal, Slot, Property, QByteArray, QTimer
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from stupidArtnet import StupidArtnet

# import local modules
from dmx_array import DMXArray
from utils import parse_qlc_workspace, change_to_parent_dir_if_in_main
from config import parse_arguments 

def change_to_parent_dir_if_in_main():
    current_dir = os.path.basename(os.getcwd())
    if current_dir == "main":
        os.chdir("..")
        logging.info(f"Changed directory to parent: {os.getcwd()}")

if __name__ == "__main__":
    # Set up logging
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

    # Change directory to parent if inside 'main'
    change_to_parent_dir_if_in_main()

    # Parse command line arguments
    parser = argparse.ArgumentParser(description="LaserGarden DMX Controller")
    parser.add_argument("--target-ip", type=str, default="192.168.7.99", help="IP address of the target Art-Net device")
    parser.add_argument("--preset", type=str, help="Path to the initial preset file to load")
    args = parser.parse_args()

    initial_preset = None
    if args.preset:
        if os.path.isabs(args.preset):
            initial_preset = args.preset
        else:
            # Search in presets first
            preset_path = os.path.join("presets", args.preset)
            if os.path.exists(preset_path):
                initial_preset = preset_path
            else:
                # Search in the current directory
                if os.path.exists(args.preset):
                    initial_preset = args.preset
                else:
                    logging.warning(f'Initial preset file {args.preset} not found in presets or current directory')

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    dmx_array = DMXArray(args.target_ip, initial_preset)
    engine.rootContext().setContextProperty("dmxArray", dmx_array)

    engine.load(QUrl("app/main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)

    # Save last configuration on exit and set all channels to 0
    def save_last_config_on_exit():
        dmx_array.save_last_config()
        dmx_array.set_all_channels_to_zero()
        logging.info("Saved last configuration and set all channels to 0 on exit")

    app.aboutToQuit.connect(save_last_config_on_exit)

    # Signal handler for Ctrl+C
    def signal_handler(sig, frame):
        print('Ctrl+C pressed, exiting...')
        app.quit()

    signal.signal(signal.SIGINT, signal_handler)

    sys.exit(app.exec())
