<%@ tag description="pagination" pageEncoding="UTF-8"%>
<%@ tag import="java.util.ArrayList" %>
<%@ attribute name="recordCount" type="java.lang.Integer" required="true" %>
<%@ attribute name="pageSize" type="java.lang.Integer" required="true" %>
<%@ attribute name="queryStringName" type="java.lang.String" required="true" %>
<%! 
private class Page { 
    int page; 
    String label;
    
    Page(int page, String label) {
        this.page = page;
        this.label = label;
    }
} 
//실제페이지와 표시될 번호 1번부터 시작됨
%>

<%
int recordCount = (Integer)jspContext.getAttribute("recordCount");
int pageSize = (Integer)jspContext.getAttribute("pageSize");
String name = (String)jspContext.getAttribute("queryStringName");
//jsp에서 받은 값들
int currentPage = 1;
if (request.getParameter(name) != null)
    currentPage = Integer.parseInt(request.getParameter(name));
//기본페이지는 1로 하되 리퀘스트파라미터 pg로 무엇가를 받았으면 그것을 현재페이지로 한다.
int pageCount = recordCount / pageSize;
if (pageCount * pageSize < recordCount) ++pageCount;
//페이지수*페이지사이즈가 전체 레코드수보다 작으면 페이지수+1
String queryString = request.getQueryString();
//url에서 쿼리스트링 받아와서 저장
if (queryString == null)
    queryString = name + "=%d";
//비어있을 경우 pg=%d를 저장
else if (queryString.matches(".*" + name + "=[0-9]+.*"))
    queryString = queryString.replaceAll(name + "=[0-9]+", name + "=%d");
//쿼리스트링에 pg=숫자가 있을 경우 pg=%d로 변경
else
    queryString = queryString + "&" + name + "=%d";
//비어있지 않지만 pg에 해당되는 내용이 없을 경우 앞의 내용+pg=%d 형태로 저장
String url = request.getRequestURI() + "?" + queryString;
//그래서 최종 url은 '기존url+?+저장한 쿼리스트링' 형태로
if (currentPage > pageCount) currentPage = pageCount;
//현재페이지가 원래 최대페이지수보다 많을 경우 최대페이지수로 변경
int base = ((currentPage - 1) / 10) * 10;
//아래 표시한 페이지번호 시작
ArrayList<Page> pages = new ArrayList<Page>();
if (base > 0) pages.add(new Page(base, "&lt;"));
//페이지번호가 10번대이상일 경우 < 넣어준다
for (int i = 1; i <= 10; ++i) {
    int n = base + i;
    if (n > pageCount) break; //필요한 전체페이지만큼만
    pages.add(new Page(n, String.valueOf(n)));
}
int n = base + 11;
if (n <= pageCount) //남은 페이지가 11개 이상이면 마지막 자리에 > 넣어주기
    pages.add(new Page(n, "&gt;"));
%>
<ul class="pagination">
  <% for (Page p : pages) { %>
    <li class='<%= p.page == currentPage ? "active" : "" %>'>
        <a href='<%= String.format(url, p.page) %>'><%= p.label %></a>
    </li>    
  <% } %>
</ul>
