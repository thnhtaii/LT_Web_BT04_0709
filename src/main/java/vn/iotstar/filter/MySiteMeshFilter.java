package vn.iotstar.filter;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

public class MySiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        // 01 Template Bootstrap Decorator duy nhất cho toàn bộ hệ thống
        builder.addDecoratorPath("/*", "/WEB-INF/decorators/web.jsp")
               .addExcludedPath("/image*")
               .addExcludedPath("/assets/*")
               .addExcludedPath("/static/*")
               .addExcludedPath("/uploads/*");
    }
}
