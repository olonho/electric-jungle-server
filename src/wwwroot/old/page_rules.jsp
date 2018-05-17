<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>

<jsp:include page="<%="rules_"+(ssn.lang != null ? ssn.lang : "ru")+".jsp"%>"/>
