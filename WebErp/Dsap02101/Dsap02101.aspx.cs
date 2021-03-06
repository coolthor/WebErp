﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using DCNP005;
using Dinp02301;
using System.Web.UI.WebControls;

public partial class Dsap02101_Dsap02101 : System.Web.UI.Page
{
    public string AppVersion = "v18.04.15";
    /// <summary>
    /// 公司代號下拉選單來源
    /// </summary>
    public List<Cnf07> BcodeList = null;



    /// <summary>
    /// 異動代號下拉選單來源
    /// </summary>
    public List<Cnf10> InReasonList = null;

    /// <summary>
    /// 幣別下拉選單來源
    /// </summary>
    public List<Cnf10> CurrencyList = null;

    protected void Page_Load(object sender, EventArgs e)
    {
        BcodeList = Cnf07.GetList();
        InReasonList = Cnf10.GetList("S15");
        CurrencyList = Cnf10.GetList("073");

    }
}