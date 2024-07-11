import os
import sys
import json
import logging
from PySide6.QtCore import QObject, Property, Signal, Slot
from PySide6.QtCore import QTimer, QByteArray
from stupidArtnet import StupidArtnet
from utils import SceneManager

class DMXArray(QObject):
    valueChanged = Signal(int, int, arguments=['index', 'value'])

    def __init__(self, target_ip, initial_preset=None):
        super().__init__()
        self.scene_manager = SceneManager()
        self.num_channels = 34  # Handle only 34 channels
        self._dmx_array = bytearray(self.num_channels)  # Initialize with 34 bytes (0-255 values)
        self.last_preset = "presets/last_config.json"
        self.default_preset = "presets/default.json"
        self.initial_preset = initial_preset

        # Initialize Art-Net device (Receiving IP)
        self.artnet = StupidArtnet(target_ip, 0, self.num_channels, 30)  # Target IP, Universe, Packet size, FPS
        self.artnet.set(self._dmx_array)
        self.artnet.start()

        if not self.verify_connection():
            logging.error(f"Could not establish connection to Art-Net device at {target_ip}")
            sys.exit(1)

        # Load the last configuration first
        if os.path.exists(self.last_preset):
            self.load_last_configuration()
        elif self.initial_preset:
            self.load_configuration(self.initial_preset)
        else:
            self.load_default()

        # Timer to send the full DMX array every second
        self.timer = QTimer()
        self.timer.timeout.connect(self.send_full_dmx_array)
        self.timer.start(1000)  # 1 second interval

    def verify_connection(self):
        try:
            # Send a test packet to verify the connection
            self.artnet.set(bytearray([0] * self.num_channels))
            self.artnet.show()
            return True
        except Exception as e:
            logging.error(f"Error verifying connection: {e}")
            return False

    @Slot(int, result=int)
    def get_value(self, index):
        if 0 <= index < self.num_channels:
            return self._dmx_array[index]
        return 0

    @Slot(int, int)
    def set_value(self, index, value):
        if 0 <= index < self.num_channels:
            self._dmx_array[index] = value
            self.valueChanged.emit(index, value)
            self.artnet.set(self._dmx_array)
            self.artnet.show()  # Immediately send updated DMX data
            logging.info(f'Set DMX value at index {index} to {value}')
            self.adjust_array_size()

    @Property(QByteArray)
    def data(self):
        return QByteArray(self._dmx_array)

    def send_full_dmx_array(self):
        # Send the relevant part of the DMX array
        self.artnet.show()
        logging.debug('Sent full DMX array')

    def adjust_array_size(self):
        if len(self._dmx_array) > self.num_channels:
            # Remove trailing elements if array is too large
            self._dmx_array = self._dmx_array[:self.num_channels]
        elif len(self._dmx_array) < self.num_channels:
            # Add elements to the end if array is too small
            self._dmx_array.extend(bytearray(self.num_channels - len(self._dmx_array)))

    @Slot(str)
    def save_configuration(self, filename):
        os.makedirs(os.path.dirname(filename), exist_ok=True)
        data_to_save = []
        for index, value in enumerate(self._dmx_array):
            data_to_save.append(index)
            data_to_save.append(value)
        with open(filename, 'w') as file:
            json.dump(data_to_save, file)
        logging.info(f'Saved configuration to {filename}')

    def apply_indexed_values(self, config):
        for i in range(0, len(config), 2):
            index = config[i]
            value = config[i + 1]
            self.set_value(index, value)
        self.adjust_array_size()

    @Slot(str, str, str)
    def load_scene(self, beam, group, scene_name):
        scene_data = self.scene_manager.get_scene_data(beam, group, scene_name)
        if scene_data is not None:
            # Implement the logic to load the scene data
            print(f"Loading scene {scene_name} for beam {beam}, group {group}")
            self.apply_indexed_values(scene_data)
        else:
            print(f"Scene {scene_name} not found for beam {beam}, group {group}")

    @Slot(str)
    def load_configuration(self, filename):
        if os.path.exists(filename):
            with open(filename, 'r') as file:
                config = json.load(file)
                self.apply_indexed_values(config)
                logging.info(f'Loaded configuration from {filename}')
        else:
            logging.warning(f'Configuration file {filename} not found')

    def load_last_configuration(self):
        self.load_configuration(self.last_preset)

    @Slot()
    def save_preset(self):
        self.save_configuration("presets/preset.json")

    @Slot()
    def load_preset(self):
        self.load_configuration("presets/preset.json")

    @Slot()
    def save_default(self):
        self.save_configuration(self.default_preset)

    @Slot()
    def load_default(self):
        self.load_configuration(self.default_preset)

    @Slot()
    def save_last_config(self):
        self.save_configuration(self.last_preset)

    @Slot(list, str)
    def save_selected_channels(self, channels, filename):
        data_to_save = []
        for index in channels:
            data_to_save.append(index)
            data_to_save.append(self._dmx_array[index])
        os.makedirs(os.path.dirname(filename), exist_ok=True)
        with open(filename, 'w') as file:
            json.dump(data_to_save, file)
        logging.info(f'Saved selected channels to {filename}')

    @Slot(list, str)
    def load_selected_channels(self, channels, filename):
        if os.path.exists(filename):
            with open(filename, 'r') as file:
                config = json.load(file)
                for i in range(0, len(config), 2):
                    index = config[i]
                    value = config[i + 1]
                    if index in channels:
                        self._dmx_array[index] = value
                self.adjust_array_size()
                self.artnet.set(self._dmx_array)
                self.valueChanged.emit(-1, -1)  # Signal that the entire array has changed
                logging.info(f'Loaded selected channels from {filename}')
                self.print_configuration()
        else:
            logging.warning(f'Configuration file {filename} not found')

    def print_configuration(self):
        logging.info(f"Current DMX Configuration: {list(self._dmx_array)}")

    @Slot()
    def set_all_channels_to_zero(self):
        for i in range(len(self._dmx_array)):
            self._dmx_array[i] = 0
        self.artnet.set(self._dmx_array)
        self.artnet.show()
        logging.info("Set all DMX channels to 0")

    @Slot()
    def reset(self):
        self._dmx_array[0] = 1
        for i in range(1, len(self._dmx_array)):
            self._dmx_array[i] = 0
        self.artnet.set(self._dmx_array)
        self.artnet.show()
        self.valueChanged.emit(-1, -1)  # Signal that the entire array has changed
        logging.info("Reset DMX channels: first channel set to 1, rest set to 0")

    @Slot(result=list)
    def list_presets(self):
        presets_folder = "presets"
        if not os.path.exists(presets_folder):
            return []
        return [os.path.splitext(f)[0] for f in os.listdir(presets_folder) if f.endswith('.json') and f not in ['default.json', 'last_config.json']]