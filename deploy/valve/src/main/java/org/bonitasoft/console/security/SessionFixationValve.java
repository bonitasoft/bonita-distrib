/**
 * Copyright (C) 2012 BonitaSoft S.A.
 * BonitaSoft, 31 rue Gustave Eiffel - 38000 Grenoble
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2.0 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 */
package org.bonitasoft.console.security;

import java.io.IOException;

import javax.servlet.ServletException;

import org.apache.catalina.Session;
import org.apache.catalina.authenticator.Constants;
import org.apache.catalina.authenticator.SavedRequest;
import org.apache.catalina.connector.Request;
import org.apache.catalina.connector.Response;
import org.apache.catalina.valves.ValveBase;

/**
 * SessionFixationValve
 * 
 * See more details at : http://www.gslab.com/component/k2/item/76-session_fixation
 * 
 * @author Ruiheng Fan
 */ 
public class SessionFixationValve extends ValveBase {

	private String authenticationUrl = "loginservice";

	public void setAuthenticationUrl(String authenticationUrl) {

		if (authenticationUrl.equals("")) {
			throw new IllegalArgumentException("String is empty.");
		}
		this.authenticationUrl = authenticationUrl;
	}

	@Override
	public void invoke(Request req, Response response) throws IOException,
			ServletException {
		if (req.getRequestURI().contains(authenticationUrl)) {
			// check for the login URI, only after a login
			// we want to renew the session

			// save old session
			Session oldSession = req.getSessionInternal(true);
			SavedRequest saved = (SavedRequest) oldSession
					.getNote(Constants.FORM_REQUEST_NOTE);
			// invalidate old session
			req.getSession(true).invalidate();
			req.setRequestedSessionId(null);
			req.clearCookies();

			// create a new session and set it to the request
			Session newSession = req.getSessionInternal(true);
			req.setRequestedSessionId(newSession.getId());

			// copy data from the old session
			// to the new one
			if (saved != null) {
				newSession.setNote(Constants.FORM_REQUEST_NOTE, saved);
			}
		}
		// after processing the request forward it
		getNext().invoke(req, response);
	}

}
