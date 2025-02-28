import json
import os
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn, RobotNotRunningError
from json2html import *


def run_axe(driver, js_file):
    with open(js_file, 'r') as file:
        axe_script = file.read()

    driver.execute_script(axe_script)

    result = driver.execute_async_script('var callback = arguments[arguments.length - 1];axe.run().then(results => callback(results))')
    #logger.info(result)

    try:
        robot_output = BuiltIn().get_variable_value('${OUTPUT DIR}')
    except RobotNotRunningError:
        robot_output = os.getcwd()

    with open(f"{robot_output}/report.json", "w") as report:
        report.write(json.dumps(eval(str(result)), indent=2))


    violations = len(result['violations'])
    logger.info(f'violations: {violations}')

    # descriptions = []
    # for i, v in enumerate(result['violations']):
    #     descriptions.append(f"{i+1}:{v['help']} - {v['helpUrl']}")
    table = json2html.convert(result['violations'])

    # if descriptions:
    #     logger.info(f'{descriptions}')
    logger.info(table, html=True)
    logger.info(f"<a href='{robot_output}/report.json'>Full results</a>", html=True)

    

    if violations:
        raise ValueError(f"There were {violations} violations in accessibility checks!!")
