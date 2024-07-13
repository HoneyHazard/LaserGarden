import sys
import signal
import logging
import os
from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from config import parse_arguments
from utils import change_to_parent_dir_if_in_main, parse_qlc_workspace
from utils import SceneManager
from dmx_array import DMXArray

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

    change_to_parent_dir_if_in_main()

    args = parse_arguments()

    # Enable the virtual keyboard
    os.environ['QT_IM_MODULE'] = 'qtvirtualkeyboard'
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    target_ip = args.get('target_ip', None)
    initial_preset = args.get('preset', None)
    device = "other"
    if args.get('ola002', False):
        device = "ola002"
    elif args.get('gla001', False):
        device = "gla001"

    dmx_array = DMXArray(target_ip, initial_preset, device)
    dmx_array.ensure_preset_and_scene_dirs_exist()

    qlc_workspace = args.get('qlc_workspace', None)
    if qlc_workspace:
        logging.info(f"Importing QLC workspace: {qlc_workspace}")
        scenes = parse_qlc_workspace(qlc_workspace, device)

    # Initialize SceneManager
    scene_manager = SceneManager(dmx_array.get_scene_dir())
    scenes = scene_manager.scenes
     # Generate tooltips if fixture file is provided
    
    qlc_fixture = args.get('qlc_fixture', None)
    if (qlc_fixture is None):
        testPath = os.path.join('qlcplus_gruolin_olaalite_a001_a002', device) + '.qxf'
        if os.path.exists(testPath):
            qlc_fixture = testPath
    tooltips = {}
    if qlc_fixture:
        logging.info(f"Generating tooltips from fixture file: {qlc_fixture}")
        tooltips = dmx_array.generate_tooltips(qlc_fixture)

    
    # View Params
    showTooltip = args.get('tooltip', False)
    modularView = args.get('modular', False)

    # Pass objects and params to QML
    engine.rootContext().setContextProperty("sceneManager", scene_manager)
    engine.rootContext().setContextProperty("dmxArray", dmx_array)
    engine.rootContext().setContextProperty("pyShowTooltipSidebar", showTooltip)
    engine.rootContext().setContextProperty("pyModularViewMode", modularView)
    engine.rootContext().setContextProperty("tooltips", tooltips)

    engine.load(QUrl("app/Main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)


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
