Class Sample.RestService Extends %CSP.REST
{

/// IRIS can automatically handle CORS requests for us
Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <Route Url="/test" Method="GET" Call="Test" />
  <Route Url="/list" Method="GET" Call="List" />
  <Route Url="/add" Method="POST" Call="Add" />
</Routes>
}

/// This is a very simple method to test if our service is working
ClassMethod Test() As %Status
{
    write "OK!"
    quit $$$OK
}

ClassMethod List() As %Status
{
  set list=[],sc=1
  set sql="SELECT Url, Description, DateAdded, TimeAdded FROM Sample.Bookmark"
  set Statement = ##class(%SQL.Statement).%New()
  set sc=$$$ADDSC(sc,Statement.%Prepare(sql))
  set Result = Statement.%Execute()
  if (Result.%SQLCODE<0) {
    set sc=$$$ADDSC(sc,$$$ERROR(5001, "Error executing sql statement"))
  }
  while Result.%Next() {
    set bookmark={"url":(Result.Url),"description":(Result.Description),
    "dateAdded":($zd(Result.DateAdded,3)),"timeAdded":($zt(Result.TimeAdded,2))
    }
    do list.%Push(bookmark)
  }

  if $$$ISOK(sc) write list.%ToJSON()

  return sc
}

ClassMethod Add() As %Status
{
  set sc=$$$OK
  set jsonRequest=##class(%Library.DynamicObject).%FromJSON(%request.Content)
  set Bookmark=##class(Sample.Bookmark).%New()
  set Bookmark.Url=jsonRequest.url
  set Bookmark.Description=jsonRequest.description
  set Bookmark.DateAdded=+$horolog
  set Bookmark.TimeAdded=$piece($horolog,",",2)
  set sc=$$$ADDSC(sc,Bookmark.%Save())
  return sc
}

}
