using System;
using System.Threading;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;

namespace EmotionCalc
{
    public partial class Form1 : Form
    {

        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog1.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                label1.Text = Properties.Settings.Default.folderPath = folderBrowserDialog1.SelectedPath;
            }
            if (!Properties.Settings.Default.folderPath.EndsWith(@"\")) Properties.Settings.Default.folderPath += @"\";
            Properties.Settings.Default.Save();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (openFileDialog1.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                label2.Text = Properties.Settings.Default.listPath = openFileDialog1.FileName;
            }

            Properties.Settings.Default.Save();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            label1.Text = Properties.Settings.Default.folderPath;
            label2.Text = Properties.Settings.Default.listPath;
            label3.Text = Properties.Settings.Default.pdPath;
            d1.Value = Properties.Settings.Default.d1;
            d2.Value = Properties.Settings.Default.d2;
            e1.Value = Properties.Settings.Default.e1;
            e2.Value = Properties.Settings.Default.e2;
        }

        private void button6_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog1.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                label3.Text = Properties.Settings.Default.pdPath = folderBrowserDialog1.SelectedPath;
            }
            if (!Properties.Settings.Default.pdPath.EndsWith(@"\")) Properties.Settings.Default.pdPath += @"\";
            Properties.Settings.Default.Save();
        }

        private void EmoWorker()
        {
            Dictionary<DateTime, int> emoc = new Dictionary<DateTime, int>();
            string dictPath = "emotion_dict.txt";
            EmotionCalc ec = new EmotionCalc(dictPath);
            foreach (string l in File.ReadAllLines(Properties.Settings.Default.listPath))
            {
                string code = l.Substring(0, 6);
                string path = Properties.Settings.Default.folderPath + "CLICK" + code;
                if (!File.Exists(path + ".txt")) continue;
                if (File.Exists(path + ".emo")) continue;
                using (var sw = new StreamWriter(path + ".emo"))
                {
                    using (var sr = new StreamReader(path + ".txt"))
                    {
                        string line = "";
                        while ((line = sr.ReadLine()) != null)
                        {
                            string date = "", content = "";
                            DateTime mydate;
                            if (line.Length < 8) continue;
                            content = line.Substring(line.IndexOf('#') + 1);
                            date = line.Substring(0, line.IndexOf('\t'));
                            if (!DateTime.TryParse(date, out mydate)) continue;
                            mydate = mydate.Date;
                            int ev = ec.CalcEmotion(content);
                            if (!emoc.ContainsKey(mydate)) emoc.Add(mydate, ev); else emoc[mydate] += ev;
                        }
                    }
                    foreach (var p in emoc)
                    {
                        sw.WriteLine(p.Key.ToShortDateString() + "\t" + p.Value);
                    }
                }
                this.Invoke(new Action(() => { listBox1.Items.Add(code); }));
            }
            MessageBox.Show("完成！");
        }

        private double[] ReadPriceData(string code)
        {
            double[] vec = new double[(int)Properties.Settings.Default.d2.Subtract(Properties.Settings.Default.d1).TotalDays + 1];
            code = code.Substring(0, 6);
            if (code.CompareTo("600000") < 0) code = "SZ" + code; else code = "SH" + code;
            double yesterdayclosep = -1;
            if (!File.Exists(Properties.Settings.Default.pdPath + code + ".txt")) return null;
            foreach (string line in File.ReadAllLines(Properties.Settings.Default.pdPath + code + ".txt"))
            {
                var cols = line.Split('\t');
                if (cols.Length < 5) continue;
                string date = cols[0];
                DateTime dt;
                if (!DateTime.TryParse(date, out dt)) continue;
                if (dt < Properties.Settings.Default.d1 || Properties.Settings.Default.d2 < dt) continue;
                int index = (int)dt.Subtract(Properties.Settings.Default.d1).TotalDays;
                double closep = double.Parse(cols[4]);
                if (yesterdayclosep < 0) yesterdayclosep = closep;
                double perc = (closep - yesterdayclosep) / yesterdayclosep * 100;
                if (perc == 0) vec[index] = double.NaN;
                vec[index] = perc;
            }
            for (int i = 1; i < vec.Length; ++i) if (vec[i] == 0) vec[i] = vec[i - 1]; else if (double.IsNaN(vec[i])) vec[i] = 0;
            return vec;
        }

        private double[] ReadEmo(string code)
        {
            double[] vec = new double[(int)Properties.Settings.Default.e2.Subtract(Properties.Settings.Default.e1).TotalDays + 1];
            code = "CLICK" + code.Substring(0, 6);
            if (!File.Exists(Properties.Settings.Default.folderPath + code + ".emo")) return null;
            foreach (string line in File.ReadAllLines(Properties.Settings.Default.folderPath + code + ".emo"))
            {
                var cols = line.Split('\t');
                if (cols.Length < 2) continue;
                string date = cols[0];
                DateTime dt;
                if (!DateTime.TryParse(date, out dt)) continue;
                if (dt < Properties.Settings.Default.e1 || Properties.Settings.Default.e2 < dt) continue;
                int index = (int)dt.Subtract(Properties.Settings.Default.e1).TotalDays;
                double val = double.Parse(cols[1]);
                vec[index] = val;
            }
            for (int i = 1; i < vec.Length; ++i) if (vec[i] == 0) vec[i] = vec[i - 1];
            return vec;
        }

        private void OpenFile(string path)
        {
            Process p = new Process();
            p.StartInfo.FileName = path;
            p.Start();
        }

        private void writeArray(StreamWriter sw, double[] a)
        {
            foreach (double x in a) sw.Write(" " + x);
            sw.WriteLine();
        }

        private void EmoPdPearsonWorker()
        {
            using (var sw = new StreamWriter("emo-pd-pearson.txt"))
            {
                foreach (string l in File.ReadAllLines(Properties.Settings.Default.listPath))
                {
                    double[] pd = ReadPriceData(l);
                    double[] em = ReadEmo(l);
                    if (pd == null || em == null) continue;
                    double res = Pearson(em, pd);
                    sw.WriteLine(l + "\t" + res);
                    writeArray(sw, pd);
                    writeArray(sw, em);
                    this.Invoke(new Action(() => { listBox1.Items.Add(l); }));
                }
            }
            MessageBox.Show("完成！");
            OpenFile("emo-pd-pearson.txt");
        }

        private void EmoPdDTWWorker()
        {
            using (var sw = new StreamWriter("emo-pd-dtw.txt"))
            {
                foreach (string l in File.ReadAllLines(Properties.Settings.Default.listPath))
                {
                    double[] pd = ReadPriceData(l);
                    double[] em = ReadEmo(l);
                    if (pd == null || em == null) continue;
                    double res = DTW(em, pd);
                    sw.WriteLine(l + "\t" + res);
                    writeArray(sw, pd);
                    writeArray(sw, em);
                    this.Invoke(new Action(() => { listBox1.Items.Add(l); }));
                }
            }
            MessageBox.Show("完成！");
            OpenFile("emo-pd-dtw.txt");
        }

        private double mean(double[] a)
        {
            double t = 0; foreach (double x in a) t += x; return t / a.Length;
        }

        private double std(double[] a, double m = double.NaN)
        {
            if (double.IsNaN(m)) m = mean(a);
            double t = 0;
            foreach (double x in a) t += (x - m) * (x - m);
            return Math.Sqrt(t / a.Length);
        }

        private double min3(double a, double b, double c)
        {
            return Math.Min(Math.Min(a, b), c);
        }

        private double Pearson(double[] a, double[] b)
        {
            int len = Math.Min(a.Length, b.Length);
            double t = 0;
            double am = mean(a), bm = mean(b), aS = std(a, am), bS = std(b, bm);
            for (int i = 0; i < len; ++i)
            {
                t += (a[i] - am) / aS * (b[i] - bm) / bS;
            }
            return t / (len - 1);
        }

        private double[] normalize(double[] x)
        {
            double[] a = new double[x.Length];
            Array.Copy(x, a, x.Length);
            double m = mean(a);
            double tot = std(a, m);
            if (tot == 0) return a;
            for (int i = 0; i < a.Length; ++i) a[i] = (a[i] - m) / tot;
            return a;
        }

        private double DTW(double[] x, double[] y)
        {
            double[] a = normalize(x), b = normalize(y);
            int n = a.Length, m = b.Length;
            double[,] N = new double[n, m];
            N[0, 0] = Math.Abs(a[0] - b[0]);
            for (int i = 0; i < n; i++)
            {
                for (int j = 0; j < m; j++)
                {
                    if (i == 0 && j > 0)
                    {
                        N[i, j] = N[i, j - 1] + Math.Abs(a[i] - b[j]); //首行计算公式
                    }
                    else if (j == 0 && i > 0)
                    {
                        N[i, j] = N[i - 1, j] + Math.Abs(a[i] - b[j]); //首列计算公式
                    }
                    else if (i > 0 && j > 0)
                    {
                        N[i, j] = min3(N[i - 1, j] + Properties.Settings.Default.cost + Math.Abs(a[i - 1] - b[j]),
                            N[i, j - 1] + Properties.Settings.Default.cost + Math.Abs(a[i] - b[j - 1]),
                            N[i - 1, j - 1] + Math.Abs(a[i] - b[j]));
                        // min是最小值函数
                    }
                }
            }
            return N[n - 1, m - 1];
        }

        private void button4_Click(object sender, EventArgs e)
        {
            listBox1.Items.Clear();
            new Thread(new ThreadStart(EmoPdPearsonWorker)).Start();
        }

        private void button5_Click(object sender, EventArgs e)
        {
            listBox1.Items.Clear();
            new Thread(new ThreadStart(EmoPdDTWWorker)).Start();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            listBox1.Items.Clear();
            new Thread(new ThreadStart(EmoWorker)).Start();
        }

        private void d1_ValueChanged(object sender, EventArgs e)
        {
            Properties.Settings.Default.d1 = d1.Value;
            Properties.Settings.Default.Save();
        }

        private void d2_ValueChanged(object sender, EventArgs e)
        {
            Properties.Settings.Default.d2 = d2.Value;
            Properties.Settings.Default.Save();
        }

        private void e1_ValueChanged(object sender, EventArgs e)
        {
            Properties.Settings.Default.e1 = e1.Value;
            Properties.Settings.Default.Save();
        }

        private void e2_ValueChanged(object sender, EventArgs e)
        {
            Properties.Settings.Default.e2 = e2.Value;
            Properties.Settings.Default.Save();
        }
    }

   public class EmotionCalc
   {
       Dictionary<string, int> dict = new Dictionary<string, int>();
       int maxLen = 0;

       public EmotionCalc(string dictPath)
       {
           foreach (string l in File.ReadAllLines(dictPath))
           {
               var cols = l.Split('\t');
               if (cols.Length < 3) continue;
               if (dict.ContainsKey(cols[0])) continue;
               dict.Add(cols[0], int.Parse(cols[2]));
               maxLen = Math.Max(maxLen, cols[0].Length);
           }
       }

       public int CalcEmotion(string s)
       {
           int emo = 0;
           int len = s.Length;
           int i = 0, l = 0;
           for (i = 0; i < len; ++i)
           {
               int lv = 0;
               string st = "";
               for (l = 0; l < maxLen; ++l)
               {
                   st += s[i + l];
                   if (!dict.ContainsKey(st)) break;
                   lv = dict[st];
               }
               i += l;
               emo += lv;
           }
           return emo;
       }
   }
    
 
}
