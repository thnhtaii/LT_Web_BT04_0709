package vn.iotstar.filter;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

public class MySiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        // SiteMesh mặc định dùng thư mục /WEB-INF/decorators/
        // Do đó mapping "/web.jsp" sẽ trỏ chính xác đến /WEB-INF/decorators/web.jsp
        builder.addDecoratorPath("/*", "/web.jsp")
               .addExcludedPath("/image*")
               .addExcludedPath("/assets/*");
    }
}
