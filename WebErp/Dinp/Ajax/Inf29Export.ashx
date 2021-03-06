﻿<%@ WebHandler Language="C#" Class="Inf29Export" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Web;
using System.Web.SessionState;
using Dinp02301;
using DCNP005;


public class Inf29Export : IHttpHandler, IRequiresSessionState
{
    
    public void ProcessRequest (HttpContext context) {
        Cnf05[] inf29FieldList = context.Session["in29ExportFields"] as Cnf05[];
        Cnf05[] inf29aFieldList = context.Session["in29aExportFields"] as Cnf05[];

        List<int> inf29IdList = context.Session["exportItems"] as List<int>;
        int excelVersion = (int)context.Session["exportExcelVersion"];

        context.Session.Remove("in29ExportFields");
        context.Session.Remove("in29aExportFields");
        context.Session.Remove("exportItems");
        context.Session.Remove("exportExcelVersion");
        
        if (inf29IdList == null)
        {
            throw new Exception("Export file failed.");
        }
        var inf29rows = Inf29.GetExportItems(inf29FieldList, inf29aFieldList, inf29IdList);
//        var inf29aList = Inf29a.GetExportItems(inf29aFieldList, inf29IdList);

        var excel = Inf29.ExportExcelNpoi(inf29FieldList, inf29aFieldList, inf29rows, excelVersion);
//        excel = Inf29a.ExportExcelNpoi(inf29aFieldList, inf29aList, excelVersion, excel);
        
        byte[] excelBinary = null;
        using (MemoryStream ms = new MemoryStream())
        {
            excel.Write(ms);
            excelBinary = ms.ToArray();
        }

        var fileNameFull = String.Format("Export_{0}.{1}", DateTime.Now.ToString("yyyyMMdd"),
                                         excelVersion == 2003 ? "xls" : "xlsx");

        var strContentDisposition = String.Format("{0}; filename=\"{1}\"", "attachment",
                                 HttpUtility.UrlEncode(fileNameFull, System.Text.Encoding.UTF8));

        context.Response.AppendHeader("Content-Disposition", strContentDisposition); // 檔案名稱
        context.Response.AppendHeader("Content-Length", excelBinary.Length.ToString());
        context.Response.BinaryWrite(excelBinary);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}