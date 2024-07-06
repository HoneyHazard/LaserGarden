#!/usr/bin/python3

import sys
import os
import json
import argparse
from PySide6.QtCore import QUrl, QObject, Signal, Slot, Property, QByteArray, QTimer
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from stupidArtnet import StupidArtnet

class DMXArray(QObject):
    valueChanged = Signal(int, arguments=['value'])

    def __init__(self, target_ip):
        super().__init__()
        self.num_channels = 34  # Handle only 34 channels
        self._dmx_array = bytearray(self.num_channels)  # Initialize with 34 bytes (0-255 values)
        self.config_file = "last_config.json"

        # Initialize Art-Net device (Receiving IP)
        self.artnet = StupidArtnet(target_ip, 0, 512, 30)  # Target IP, Universe, Packet size, FPS
        self.artnet.start()

        # Load the last configuration
        self.load_last_configuration()

        # Timer to send the full DMX array every second
        self.timer = QTimer()
        self.timer.timeout.connect(self.send_full_dmx_array)
        self.timer.start(1000)  # 1 second interval

    @Slot(int, result=int)
    def get_value(self, index):
        if 0 <= index < self.num_channels:
            return self._dmx_array[index]
        return 0

    @Slot(int, int)
    def set_value(self, index, value):
        if 0 <= index < self.num_channels:
            self._dmx_array[index] = value
            self.valueChanged.emit(index)
            self.artnet.set_single_value(index, value)

    @Property(QByteArray)
    def data(self):
        return QByteArray(self._dmx_array)

    def send_full_dmx_array(self):
        # Send only the relevant part of the DMX array
        self.artnet.set(self._dmx_array)
        self.artnet.show()

    def save_configuration(self, filename):
        with open(filename, 'w') as file:
            json.dump(list(self._dmx_array), file)

    def load_configuration(self, filename):
        if os.path.exists(filename):
            with open(filename, 'r') as file:
                config = json.load(file)
                self._dmx_array = bytearray(config)
                for index, value in enumerate(self._dmx_array):
                    self.artnet.set_single_value(index, value)
                self.valueChanged.emit(-1)  # Signal that the entire array has changed

    def load_last_configuration(self):
        self.load_configuration(self.config_file)

    @Slot()
    def save_preset(self):
        self.save_configuration("preset.json")

    @Slot()
    def load_preset(self):
        self.load_configuration("preset.json")

if __name__ == "__main__":
    # Parse command line arguments
    parser = argparse.ArgumentParser(description="LaserGarden DMX Controller")
    parser.add_argument("--target-ip", type=str, default="192.168.7.99", help="IP address of the target Art-Net device")
    args = parser.parse_args()

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    dmx_array = DMXArray(args.target_ip)
    engine.rootContext().setContextProperty("dmxArray", dmx_array)

    engine.load(QUrl("main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())
