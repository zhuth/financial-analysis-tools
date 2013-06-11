using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Net;
using System.IO;
using System.Threading;
using HtmlAgilityPack;

namespace EastmoneyTopicSpider
{
    class Program
    {
        static int running = 0;
        const int MAX_RUNNING = 60;
        static string url = "http://guba.eastmoney.com/topic,{0}_{1}.html";
        static StreamWriter sw;

        static void Main(string[] args)
        {
            var stocks = System.IO.File.ReadAllLines("names.txt");
            sw = new System.IO.StreamWriter(DateTime.Today.ToShortDateString().Replace("/", "-") + ".txt");
            foreach (string stock in stocks)
            {
                while (running >= MAX_RUNNING) Thread.Sleep(10);
                ++running;
                Thread runner = new Thread(new ParameterizedThreadStart(fetchPage));
                runner.Start(stock.Substring(0, stock.IndexOf('\t')));
            }
            sw.Flush(); sw.Close();
        }

        static Regex regPageCount = new Regex(@"var page_num=(\d+)", RegexOptions.Compiled);

        static void fetchPage(object stock)
        {
            string stockstr = (string)stock;

            WebClient wc = new WebClient();
            string html = wc.DownloadString(string.Format(url, stock, 1));
            var m = regPageCount.Match(html);
            if (m == null) return;
            int pages_count = int.Parse(m.Value.Substring(13));

            if (!System.IO.Directory.Exists(stockstr)) System.IO.Directory.CreateDirectory(stockstr);
            for (int page = 1; page <= pages_count; ++page)
            {
                if (page > 1)
                    html = wc.DownloadString(string.Format(url, stock, page));

                Console.WriteLine(stockstr + " " + page);
                try
                {
                    HtmlDocument doc = new HtmlDocument();
                    doc.LoadHtml(html);
                    var nodes = doc.GetElementbyId("mainleft");
                    var divs = nodes.SelectNodes("//div");
                    foreach (var div in divs)
                    {
                        if (!div.HasAttributes) continue;
                        if (div.Attributes["class"] == null) continue;
                        string divclass = div.Attributes["class"].Value;
                        if (divclass == "h3" || divclass == "h4")
                        {
                            string clicks = "", replies = "", id = "";
                            foreach (var li in div.Element("ul").Elements("li"))
                            {
                                string liclass = li.Attributes["class"].Value;
                                switch (liclass)
                                {
                                    case "l1":
                                        clicks = li.InnerText;
                                        break;
                                    case "l2":
                                        replies = li.InnerText;
                                        break;
                                    case "l3":
                                        id = li.Element("a").Attributes["href"].Value;
                                        break;
                                }
                                if (!string.IsNullOrEmpty(id)) break;
                            }
                            if (!string.IsNullOrEmpty(id))
                            {
                                id = id.Substring(id.LastIndexOf(',') + 1);
                                id = id.Substring(0, id.LastIndexOf('.'));
                                Console.WriteLine(id);
                                sw.WriteLine("{0}\t{1}\t{2}", id, clicks, replies);

                                int repliesCount = int.Parse(replies) + 1;
                                int repliesPages = (int)Math.Ceiling(repliesCount / 50.0);

                                if (File.Exists(stockstr + "\\" + id + ".txt") &&
                                    new FileInfo(stockstr + "\\" + id + ".txt").Length > 0) continue;
                                using (var swt = new System.IO.StreamWriter(stockstr + "\\" + id + ".txt"))
                                {
                                    for (int repliesPage = 1; repliesPage <= repliesPages; ++repliesPage)
                                    {
                                        string htmlcontent = wc.DownloadString("http://guba.eastmoney.com/look," + stockstr + "," + id + "_" + repliesPage + ".html");
                                        HtmlDocument doct = new HtmlDocument();
                                        doct.LoadHtml(htmlcontent);

                                        var contents = doct.GetElementbyId("main").SelectNodes("//div[@class='neirong']");
                                        foreach (var content in contents)
                                        {
                                            swt.WriteLine(content.InnerText);
                                            swt.WriteLine("----------------");
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                catch { }
            }

            --running;
        }
    }
}
