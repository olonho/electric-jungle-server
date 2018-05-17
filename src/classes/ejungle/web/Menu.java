package ejungle.web;

import java.io.*;

public class Menu {
    MenuItem[] items;
    
    public Menu(MenuItem ... items) {
        this.items = items;
    }
    
    public final boolean contains(String page) {
        for (MenuItem item : items) {
            if (page.equals(item.page)) {
                return true;
            }
        }
          return false;
    }
    
}
