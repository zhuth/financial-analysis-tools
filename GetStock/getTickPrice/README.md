# 获取A股Tick

###目的：

* 获取沪深所有A股Tick数据

###代码说明

* initStockTick.py 合并条目再分为20个tickList；输入tickLists; 输出20个tickList.txt，建立StockTick\Stock、StockTickError、TickList

* getStockTick.py 获取A股Tick；输入tickList（条目子列表）；输出**Tick数据**

* startGetStockTick.sh 同时运行20个进程

* restartStockTick.py 去除已下载条目；输入StockTick\Stock；输出TickList

###参考链接：

* Tick数据：<http://market.finance.sina.com.cn/downxls.php?date=20121122&symbol=sh600000>

