import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

import org.bonitasoft.web.extension.page.PageContext
import org.bonitasoft.web.extension.page.PageController
import org.bonitasoft.web.extension.page.PageResourceProvider

class Index implements PageController {

    @Override
    void doGet(HttpServletRequest request, HttpServletResponse response, PageResourceProvider pageResourceProvider, PageContext pageContext) {
        try {
            String indexContent
            pageResourceProvider.getResourceAsStream("index.html").withStream { InputStream s ->
                indexContent = s.getText()
            }
            PrintWriter out = response.getWriter()
            out.print(indexContent)
            out.flush()
            out.close()
        } catch (Exception e) {
            e.printStackTrace()
        }
    }
}
