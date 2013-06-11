namespace StockDataChooser
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
            System.Windows.Forms.ListViewItem listViewItem17 = new System.Windows.Forms.ListViewItem("日期");
            System.Windows.Forms.ListViewItem listViewItem18 = new System.Windows.Forms.ListViewItem("开盘价");
            System.Windows.Forms.ListViewItem listViewItem19 = new System.Windows.Forms.ListViewItem("最高价");
            System.Windows.Forms.ListViewItem listViewItem20 = new System.Windows.Forms.ListViewItem("最低价");
            System.Windows.Forms.ListViewItem listViewItem21 = new System.Windows.Forms.ListViewItem("收盘价");
            System.Windows.Forms.ListViewItem listViewItem22 = new System.Windows.Forms.ListViewItem("成交手数");
            System.Windows.Forms.ListViewItem listViewItem23 = new System.Windows.Forms.ListViewItem("成交量");
            System.Windows.Forms.ListViewItem listViewItem24 = new System.Windows.Forms.ListViewItem("词频涨跌幅*");
            this.button1 = new System.Windows.Forms.Button();
            this.lblStockDir = new System.Windows.Forms.Label();
            this.datafolder = new System.Windows.Forms.FolderBrowserDialog();
            this.lvwStocks = new System.Windows.Forms.ListView();
            this.button2 = new System.Windows.Forms.Button();
            this.button3 = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.dateTimePicker1 = new System.Windows.Forms.DateTimePicker();
            this.checkBox1 = new System.Windows.Forms.CheckBox();
            this.lvwColumns = new System.Windows.Forms.ListView();
            this.button4 = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.dateTimePicker2 = new System.Windows.Forms.DateTimePicker();
            this.txtFilter = new System.Windows.Forms.TextBox();
            this.lblSelectedCount = new System.Windows.Forms.Label();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(12, 12);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(121, 30);
            this.button1.TabIndex = 0;
            this.button1.Text = "&D. 股票数据目录";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // lblStockDir
            // 
            this.lblStockDir.AutoSize = true;
            this.lblStockDir.Location = new System.Drawing.Point(139, 21);
            this.lblStockDir.Name = "lblStockDir";
            this.lblStockDir.Size = new System.Drawing.Size(41, 12);
            this.lblStockDir.TabIndex = 1;
            this.lblStockDir.Text = "label1";
            // 
            // lvwStocks
            // 
            this.lvwStocks.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.lvwStocks.CheckBoxes = true;
            this.lvwStocks.Location = new System.Drawing.Point(12, 80);
            this.lvwStocks.Name = "lvwStocks";
            this.lvwStocks.Size = new System.Drawing.Size(430, 189);
            this.lvwStocks.TabIndex = 2;
            this.lvwStocks.UseCompatibleStateImageBehavior = false;
            this.lvwStocks.View = System.Windows.Forms.View.List;
            this.lvwStocks.ItemSelectionChanged += new System.Windows.Forms.ListViewItemSelectionChangedEventHandler(this.lvwStocks_ItemSelectionChanged);
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(12, 48);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(49, 26);
            this.button2.TabIndex = 3;
            this.button2.Text = "全选";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(67, 48);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(49, 26);
            this.button3.TabIndex = 4;
            this.button3.Text = "反选";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox1.Controls.Add(this.dateTimePicker1);
            this.groupBox1.Controls.Add(this.checkBox1);
            this.groupBox1.Controls.Add(this.lvwColumns);
            this.groupBox1.Controls.Add(this.button4);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.dateTimePicker2);
            this.groupBox1.Location = new System.Drawing.Point(448, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(330, 231);
            this.groupBox1.TabIndex = 12;
            this.groupBox1.TabStop = false;
            // 
            // dateTimePicker1
            // 
            this.dateTimePicker1.Location = new System.Drawing.Point(196, 34);
            this.dateTimePicker1.Name = "dateTimePicker1";
            this.dateTimePicker1.Size = new System.Drawing.Size(124, 21);
            this.dateTimePicker1.TabIndex = 13;
            // 
            // checkBox1
            // 
            this.checkBox1.AutoSize = true;
            this.checkBox1.Location = new System.Drawing.Point(197, 173);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new System.Drawing.Size(120, 16);
            this.checkBox1.TabIndex = 18;
            this.checkBox1.Text = "生成到单个文件中";
            this.checkBox1.UseVisualStyleBackColor = true;
            // 
            // lvwColumns
            // 
            this.lvwColumns.CheckBoxes = true;
            listViewItem17.StateImageIndex = 0;
            listViewItem18.StateImageIndex = 0;
            listViewItem19.StateImageIndex = 0;
            listViewItem20.StateImageIndex = 0;
            listViewItem21.StateImageIndex = 0;
            listViewItem22.StateImageIndex = 0;
            listViewItem23.StateImageIndex = 0;
            listViewItem24.StateImageIndex = 0;
            this.lvwColumns.Items.AddRange(new System.Windows.Forms.ListViewItem[] {
            listViewItem17,
            listViewItem18,
            listViewItem19,
            listViewItem20,
            listViewItem21,
            listViewItem22,
            listViewItem23,
            listViewItem24});
            this.lvwColumns.Location = new System.Drawing.Point(6, 20);
            this.lvwColumns.Name = "lvwColumns";
            this.lvwColumns.Size = new System.Drawing.Size(184, 205);
            this.lvwColumns.TabIndex = 12;
            this.lvwColumns.UseCompatibleStateImageBehavior = false;
            this.lvwColumns.View = System.Windows.Forms.View.List;
            // 
            // button4
            // 
            this.button4.Location = new System.Drawing.Point(199, 195);
            this.button4.Name = "button4";
            this.button4.Size = new System.Drawing.Size(121, 30);
            this.button4.TabIndex = 17;
            this.button4.Text = "&G. 生成";
            this.button4.UseVisualStyleBackColor = true;
            this.button4.Click += new System.EventHandler(this.button4_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(194, 15);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(65, 12);
            this.label1.TabIndex = 14;
            this.label1.Text = "时间段：从";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(194, 62);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(17, 12);
            this.label2.TabIndex = 16;
            this.label2.Text = "到";
            // 
            // dateTimePicker2
            // 
            this.dateTimePicker2.Location = new System.Drawing.Point(196, 81);
            this.dateTimePicker2.Name = "dateTimePicker2";
            this.dateTimePicker2.Size = new System.Drawing.Size(124, 21);
            this.dateTimePicker2.TabIndex = 15;
            // 
            // txtFilter
            // 
            this.txtFilter.Location = new System.Drawing.Point(122, 51);
            this.txtFilter.Name = "txtFilter";
            this.txtFilter.Size = new System.Drawing.Size(320, 21);
            this.txtFilter.TabIndex = 13;
            this.txtFilter.Text = "筛选...";
            this.txtFilter.TextChanged += new System.EventHandler(this.txtFilter_TextChanged);
            this.txtFilter.Enter += new System.EventHandler(this.txtFilter_Enter);
            this.txtFilter.Leave += new System.EventHandler(this.txtFilter_Leave);
            // 
            // lblSelectedCount
            // 
            this.lblSelectedCount.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.lblSelectedCount.AutoSize = true;
            this.lblSelectedCount.Location = new System.Drawing.Point(448, 257);
            this.lblSelectedCount.Name = "lblSelectedCount";
            this.lblSelectedCount.Size = new System.Drawing.Size(71, 12);
            this.lblSelectedCount.TabIndex = 14;
            this.lblSelectedCount.Text = "共选择 0 项";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(790, 285);
            this.Controls.Add(this.lblSelectedCount);
            this.Controls.Add(this.txtFilter);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.button3);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.lvwStocks);
            this.Controls.Add(this.lblStockDir);
            this.Controls.Add(this.button1);
            this.Name = "Form1";
            this.Text = "股票数据选择";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
            this.Load += new System.EventHandler(this.Form1_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Label lblStockDir;
        private System.Windows.Forms.FolderBrowserDialog datafolder;
        private System.Windows.Forms.ListView lvwStocks;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.DateTimePicker dateTimePicker1;
        private System.Windows.Forms.CheckBox checkBox1;
        private System.Windows.Forms.ListView lvwColumns;
        private System.Windows.Forms.Button button4;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.DateTimePicker dateTimePicker2;
        private System.Windows.Forms.TextBox txtFilter;
        private System.Windows.Forms.Label lblSelectedCount;
    }
}

