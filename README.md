# Calendar
一个OC日历，农历/公历 节假日 农历/公历时间选择器

## 之前项目中有用到日历，所以在这里整理一下，内容比较乱，但是基本都带有注释。

## 里边lunarYearInfo.json是一个农历年月信息：每一年的每个月是否是闰月，每个月多少天（只包含1901-2049年的信息）这些信息是单独计算出来的，具体计算方法在我另一个项目中：https://github.com/531464049/GetLunarYearMonthInfo

## TiDi类是一个计算日期天干地支，生肖的类，里边只暴露了两个方法，一个计算天干地支，一个计算生肖

## LunarSolarModel类是一个换算公历/农历的类，同样只暴露两个方法，农历转公历、公历转农历
