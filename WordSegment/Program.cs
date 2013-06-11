/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Text;

using PanGu;
using PanGu.Dict;

namespace Demo
{
    static class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("PanGu Word Segment");

            string input = "", output = "";
            if (args.Length >= 2)
            {
                input = args[0];
                output = args[1];
            }
            else {
                Console.WriteLine("Usage: wordsegment <input> <output> [-pos]");
                FormDemo demo = new FormDemo();
                demo.ShowDialog();
                return;
            }

            bool showPosition = args.Length >= 3 && args[2] == "-pos";

            // init

            PanGu.Segment.Init();
            PanGu.Match.MatchOptions options = PanGu.Setting.PanGuSettings.Config.MatchOptions;
            PanGu.Match.MatchParameter parameters = PanGu.Setting.PanGuSettings.Config.Parameters;

            using (System.IO.StreamWriter sw = new System.IO.StreamWriter(output))
            {
                foreach (string doc in System.IO.File.ReadAllLines(input))
                {
                    Segment segment = new Segment();
                    ICollection<WordInfo> words = segment.DoSegment(doc, options, parameters);

                    StringBuilder wordsString = new StringBuilder();
                    foreach (WordInfo wordInfo in words)
                    {
                        if (wordInfo == null)
                        {
                            continue;
                        }

                        if (showPosition)
                        {

                            wordsString.AppendFormat("{0}/({1},{2}) ", wordInfo.Word, wordInfo.Position, wordInfo.Rank);
                        }
                        else
                        {
                            wordsString.AppendFormat("{0} ", wordInfo.Word);
                        }
                    }

                    sw.WriteLine(wordsString);

                }
                sw.Flush(); sw.Close();
            }

        }


    }
}
