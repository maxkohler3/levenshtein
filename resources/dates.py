from typing import Union
from datetime import datetime, date
from dateutil.relativedelta import relativedelta

def nth_day_of_month(origin_date: Union[datetime, str], nth_day: int=1, months: int=0, date_format: str="%Y/%m/%d", result_format: str="%Y/%-m/%-d") -> str:
    """Adds months (supports negatives) from given date and resolves the nth day of month
    Using negative integers as nth_day will return "first day of next month - nth_day"
        -> giving -1 will return the last day of month, -2 second to last and so on
    Giving 0 as nth_day results day part not being changed
    
    Examples:
    nth_day_of_month("2022/09/20", nth_day=1, months=4) -> 2023/1/1
    nth_day_of_month("2022/09/20", nth_day=-1, months=-4) -> 2022/5/31
    nth_day_of_month("2022/09/20", nth_day=0, months=2) -> 2022/11/20
    """

    if isinstance(origin_date, (datetime, date)):
        given_date = origin_date
    else:
        given_date = datetime.strptime(origin_date, date_format).date()
    
    if nth_day == 0:
        final_date = given_date + relativedelta(months=months)
    elif nth_day < 0:
        final_date = given_date + relativedelta(months=months+1, day=1) + relativedelta(days=nth_day)
    else:
        final_date = given_date + relativedelta(months=months, day=nth_day)
    return final_date.strftime(result_format)





# from typing import Union
# from datetime import datetime, date
# from dateutil.relativedelta import relativedelta

# def nth_day_of_month(origin_date: Union[datetime, str], nth_day: int=1, months: int=0, date_format: str="%Y/%m/%d", result_format: str="%Y/%-m/%-d") -> str:
#     """Adds months (supports negatives) from given date and resolves the nth day of month
#     Using negative integers as nth_day will return "first day of next month - nth_day"
#         -> giving -1 will return the last day of month, -2 second to last and so on
#     Giving 0 as nth_day results day part not being changed
    
#     Examples:
#     nth_day_of_month("2022/09/20", nth_day=1, months=4) -> 2023/1/1
#     nth_day_of_month("2022/09/20", nth_day=-1, months=-4) -> 2022/5/31
#     nth_day_of_month("2022/09/20", nth_day=0, months=2) -> 2022/11/20
#     """

#     if isinstance(origin_date, (datetime, date)):
#         given_date = origin_date
#     else:
#         given_date = datetime.strptime(origin_date, date_format).date()
    
#     if nth_day == 0:
#         final_date = given_date + relativedelta(months=months)
#     elif nth_day < 0:
#         final_date = given_date + relativedelta(months=months+1, day=1) + relativedelta(days=nth_day)
#     else:
#         final_date = given_date + relativedelta(months=months, day=nth_day)
#     return final_date.strftime(return_format)