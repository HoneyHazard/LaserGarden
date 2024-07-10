import sys
import signal
import logging
from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from config import parse_arguments
from utils import change_to_parent_dir_if_in_main, parse_qlc_workspace
from dmx_array import DMXArray

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

    change_to_parent_dir_if_in_main()
    target_ip, initial_preset, qlc_workspace = parse_arguments()

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    dmx_array = DMXArray(target_ip, initial_preset)
    engine.rootContext().setContextProperty("dmxArray", dmx_array)

    engine.load(QUrl("app/main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)

    if qlc_workspace:
        logging.info(f"Importing QLC workspace: {qlc_workspace}")
        scenes = parse_qlc_workspace(qlc_workspace)
        # Store scenes in the DMXArray object or another suitable location

    def save_last_config_on_exit():
        dmx_array.save_last_config()
        dmx_array.set_all_channels_to_zero()
        logging.info("Saved last configuration and set all channels to 0 on exit")

    app.aboutToQuit.connect(save_last_config_on_exit)

    def signal_handler(sig, frame):
        print('Ctrl+C pressed, exiting...')
        app.quit()

    signal.signal(signal.SIGINT, signal_handler)

    sys.exit(app.exec())
