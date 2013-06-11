# 获取A股列表

###目的：

获取沪深所有A股代码与中文名称

###过程：

* 从股吧获取所有A股列表（包括退市股票）*参考1*

* 检验每只股票是否退市
___

1. 如果最近季度有复权数据，则一定上市 *参考2*
2. 如果基本资料显示已经退市，则一定退市 *参考3*
3. 其余为上市但最近停牌或今年刚退市，则统计今年是否有过交易 P.S.:需改进为一年内 *参考2*
4. 最后结果可能包含刚退市但近期仍有交易报价，仍有研究价值；也可能漏选上市但一年内无交易报价的股票，其研究价值以及预测价值不大，可作为后期改进。
___

* 排序结果并输出**代码列表**和**中文与代码对照表**

###代码说明

getStockName.py 获取A股列表；无输入；输出上市代码列表、上市中文对照表、退市代码列表、退市中文对照表

###参考链接：

1. 股吧列表：<http://guba.sina.com.cn/?s=category&cid=1&page=1>
2. 复权价格：<http://money.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/600000.phtml>
3. 基本资料：<http://money.finance.sina.com.cn/corp/go.php/vCI_CorpOtherInfo/stockid/600000/menu_num/0.phtml>