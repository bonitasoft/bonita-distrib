/** Copyright (C) 2015 Bonitasoft S.A.
 * BonitaSoft, 31 rue Gustave Eiffel - 38000 Grenoble
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2.0 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */


(function () {
    'use strict';

    describe('Layout page', function () {

        var width = 1280, height = 800;

        describe('preview', function () {
            it('should display application name on the browser tab', function () {
                browser.controlFlow().execute(deployLayoutPage).then(function () {
                        browser.driver.sleep(1000);
                        browser.driver.manage().window().setSize(width, height);
                        browser.get('/designer/preview/page/layout-page/');
                        expect(browser.getTitle()).toEqual('LivingApplicationLayoutPageV3');
                    }
                );
            });
        });
    });

    function deployLayoutPage() {
        var deferred = protractor.promise.defer();

        var fs = require('fs');
        var path = require('path');
        var pageDirPath = path.join(__dirname, '/../../../../../target/');
        fs.readdir(pageDirPath, function (err, files) {
            var pagePath = files.filter(function (file) {
                return /layout-page-.*\.zip/.test(file);
            })[0];
            upload(path.join(pageDirPath, pagePath));
        });

        function upload(pagePath) {
            var restler = require('restler');

            fs.stat(pagePath, function (err, stats) {
                restler.post(browser.baseUrl + '/designer/import/page', {
                    multipart: true,
                    data: {
                        "file": restler.file(pagePath, null, stats.size, null, "application/zip")
                    }
                }).on("complete", function () {
                    deferred.fulfill();
                }).on("error", function (e) {
                    deferred.reject(e);
                }).on("fail", function (e) {
                    deferred.reject(e);
                });
            });
        }

        return deferred.promise;
    }
})
();
