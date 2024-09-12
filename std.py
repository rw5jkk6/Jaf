import numpy as np

english = [60, 70, 80]
math = [50, 60, 100]

avg_eng = np.average(english)
print(avg_eng)

avg_math = np.average(math)
print(avg_math)


std_eng = np.std(english)
std_math = np.std(math)

print(f'englishの平均は{avg_eng},ボラティリティは{std_eng:.1f}')
print(f'mathの平均は{avg_math},ボラティリティは{std_math:.1f}')
