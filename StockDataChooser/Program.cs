using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace StockDataChooser
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Application.EnableVisualStyles();
                Application.SetCompatibleTextRenderingDefault(false);
                Application.Run(new Form1());
            }
            else
            {
                if (args.Length < 6)
                {
                    Console.WriteLine("Usage:\tStockChooser <data dir> <field id>[_<field id>_<field id>...] <begin date> <end date> <output> <industry output>");
                    return;
                }
                string dataDir = args[0],
                    fields = args[1],
                    output1 = args[4],
                    output2 = args[5];
                DateTime since = DateTime.Parse(args[2]),
                    until = DateTime.Parse(args[3]);

                Form1 frm = new Form1();
                List<string> dataFiles = new List<string>();

                foreach (string s in System.IO.Directory.GetFileSystemEntries(dataDir))
                    dataFiles.Add(s.Substring(s.LastIndexOf('\\') + 1));

                frm.Generate(dataDir, dataFiles.ToArray(), fields, since, until, output1, output2, true);
            }
        }
    }
}
