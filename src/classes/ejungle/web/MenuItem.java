package ejungle.web;

public class MenuItem {
    String page;
    String url;
    
    public MenuItem(String page, String url) {
        this.page = page;
        this.url = url;
    }
    
    public MenuItem(String page) {
        this.page = page;
        this.url = "main.jsp?page=" + page;
    }
    
}
