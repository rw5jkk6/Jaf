- python3 -m pip install numpy
- python3 -m pip install scipy

```py

import numpy as np
import math
from scipy.stats import norm 


price = 35155
sqprice = 35500
date = 4
workingday= 365
rate = 0
vol = 0.3684

d1 = (np.log(price/sqprice) + (rate+vol**2/2)*date/workingday) / (vol*np.sqrt(date/workingday))
d2 = d1 - vol*np.sqrt(date/workingday)

nd1 = norm.cdf(d1)
nd2 = norm.cdf(d2)
# print(d1)
# print(d2)
# print(nd1)
# print(nd2)
call = price*nd1-sqprice*math.exp(-rate*date/workingday)*nd2
print(f"call={call:.2f}")

# put = sqprice*math.exp(-rate*date/workingday)*(-nd2) - (price * -nd1)
# print(put)

# Nd1=-d1
# Nd2=-d2
# put2 =  -(price*Nd1) + (sqprice/(pow((1+rate), date/workingday))) * Nd2
put3 = call + sqprice - price
print(f"put={put3:.2f}")
```
