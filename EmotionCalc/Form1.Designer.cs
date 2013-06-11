namespace EmotionCalc
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
            this.button1 = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.button2 = new System.Windows.Forms.Button();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.listBox1 = new System.Windows.Forms.ListBox();
            this.button3 = new System.Windows.Forms.Button();
            this.button4 = new System.Windows.Forms.Button();
            this.button5 = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.button6 = new System.Windows.Forms.Button();
            this.d1 = new System.Windows.Forms.DateTimePicker();
            this.d2 = new System.Windows.Forms.DateTimePicker();
            this.e2 = new System.Windows.Forms.DateTimePicker();
            this.e1 = new System.Windows.Forms.DateTimePicker();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(12, 12);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(116, 23);
            this.button1.TabIndex = 0;
            this.button1.Text = "选择股吧文本目录";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(134, 17);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(23, 12);
            this.label1.TabIndex = 1;
            this.label1.Text = "C:\\";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(134, 46);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(23, 12);
            this.label2.TabIndex = 3;
            this.label2.Text = "C:\\";
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(12, 41);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(116, 23);
            this.button2.TabIndex = 2;
            this.button2.Text = "选择股票列表文件";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // listBox1
            // 
            this.listBox1.FormattingEnabled = true;
            this.listBox1.ItemHeight = 12;
            this.listBox1.Location = new System.Drawing.Point(12, 199);
            this.listBox1.Name = "listBox1";
            this.listBox1.Size = new System.Drawing.Size(408, 136);
            this.listBox1.TabIndex = 4;
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(12, 170);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(116, 23);
            this.button3.TabIndex = 5;
            this.button3.Text = "计算情感分值";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // button4
            // 
            this.button4.Location = new System.Drawing.Point(134, 170);
            this.button4.Name = "button4";
            this.button4.Size = new System.Drawing.Size(116, 23);
            this.button4.TabIndex = 6;
            this.button4.Text = "计算情感-股价PC";
            this.button4.UseVisualStyleBackColor = true;
            this.button4.Click += new System.EventHandler(this.button4_Click);
            // 
            // button5
            // 
            this.button5.Location = new System.Drawing.Point(256, 170);
            this.button5.Name = "button5";
            this.button5.Size = new System.Drawing.Size(116, 23);
            this.button5.TabIndex = 7;
            this.button5.Text = "计算情感-股价DTW";
            this.button5.UseVisualStyleBackColor = true;
            this.button5.Click += new System.EventHandler(this.button5_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(134, 75);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(23, 12);
            this.label3.TabIndex = 9;
            this.label3.Text = "C:\\";
            // 
            // button6
            // 
            this.button6.Location = new System.Drawing.Point(12, 70);
            this.button6.Name = "button6";
            this.button6.Size = new System.Drawing.Size(116, 23);
            this.button6.TabIndex = 8;
            this.button6.Text = "选择股价文件夹";
            this.button6.UseVisualStyleBackColor = true;
            this.button6.Click += new System.EventHandler(this.button6_Click);
            // 
            // d1
            // 
            this.d1.Location = new System.Drawing.Point(12, 99);
            this.d1.Name = "d1";
            this.d1.Size = new System.Drawing.Size(200, 21);
            this.d1.TabIndex = 10;
            this.d1.Value = new System.DateTime(2012, 10, 1, 0, 0, 0, 0);
            this.d1.ValueChanged += new System.EventHandler(this.d1_ValueChanged);
            // 
            // d2
            // 
            this.d2.Location = new System.Drawing.Point(218, 99);
            this.d2.Name = "d2";
            this.d2.Size = new System.Drawing.Size(200, 21);
            this.d2.TabIndex = 11;
            this.d2.Value = new System.DateTime(2013, 5, 1, 0, 0, 0, 0);
            this.d2.ValueChanged += new System.EventHandler(this.d2_ValueChanged);
            // 
            // e2
            // 
            this.e2.Location = new System.Drawing.Point(218, 126);
            this.e2.Name = "e2";
            this.e2.Size = new System.Drawing.Size(200, 21);
            this.e2.TabIndex = 13;
            this.e2.Value = new System.DateTime(2013, 5, 1, 0, 0, 0, 0);
            this.e2.ValueChanged += new System.EventHandler(this.e2_ValueChanged);
            // 
            // e1
            // 
            this.e1.Location = new System.Drawing.Point(12, 126);
            this.e1.Name = "e1";
            this.e1.Size = new System.Drawing.Size(200, 21);
            this.e1.TabIndex = 12;
            this.e1.Value = new System.DateTime(2012, 10, 1, 0, 0, 0, 0);
            this.e1.ValueChanged += new System.EventHandler(this.e1_ValueChanged);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(432, 347);
            this.Controls.Add(this.e2);
            this.Controls.Add(this.e1);
            this.Controls.Add(this.d2);
            this.Controls.Add(this.d1);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.button6);
            this.Controls.Add(this.button5);
            this.Controls.Add(this.button4);
            this.Controls.Add(this.button3);
            this.Controls.Add(this.listBox1);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.button1);
            this.Name = "Form1";
            this.Text = "情感计算";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.ListBox listBox1;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Button button4;
        private System.Windows.Forms.Button button5;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button button6;
        private System.Windows.Forms.DateTimePicker d1;
        private System.Windows.Forms.DateTimePicker d2;
        private System.Windows.Forms.DateTimePicker e2;
        private System.Windows.Forms.DateTimePicker e1;
    }
}

