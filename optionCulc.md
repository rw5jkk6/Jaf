## インストール
- python3 -m pip install numpy
- python3 -m pip install scipy

## copyして使う
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

call = price*nd1-sqprice*math.exp(-rate*date/workingday)*nd2
print(f"call={call:.2f}")

# プットコールパリティからプット価格を求める cf25   
# C:コール価格, K:権利行使価格, P:プット価格, S:時価
# C+K=P+S
# P=C+K-S
put = call + sqprice - price
print(f"put={put:.2f}")
```
