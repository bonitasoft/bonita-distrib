<%@ page session="false" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%
response.setStatus(response.SC_MOVED_PERMANENTLY);
response.setHeader("Location", "/bonita/");
%>
