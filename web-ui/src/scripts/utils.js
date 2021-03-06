import { apiConfig } from './api-config';

function getJWT() {
  return localStorage.getItem("jwt");
}

function removeJWT() {
  localStorage.removeItem("jwt");
}

function callAuth(userName, password, authHandler) {
  $.ajax({
    type: 'GET',
    url: apiConfig.currunt.api.baseUrl + '/auth',
    aysnc: true,
    cache: false,
    headers: {
      'Authorization': 'Basic ' + btoa(userName + ':' + password)
    },
    error: function (jqXHR, textStatus, error) {
      var responseCode = jqXHR.status;
      var responseBody = jqXHR.responseJSON;
      authHandler(responseCode, responseBody);
    },
    success: function (data, textStatus, jqXHR) {
      //obtain error from server
      var responseCode = jqXHR.status;
      var jwt = jqXHR.getResponseHeader('Authorization');
      authHandler(responseCode, jwt);
    }
  });
}



//TODO: Write single method for GET,PUT,POST,DELETE
function handleGet(resourceUrl, handler) {
  $.ajax({
    type: 'GET',
    url: resourceUrl,
    aysnc: true,
    cache: false,
    headers: {
      'Authorization': getJWT()
    },
    error: function (jqXHR, textStatus, error) {
      handler(jqXHR.status, jqXHR.responseJSON);
    },
    success: function (data, textStatus, jqXHR) {
      handler(jqXHR.status, jqXHR.responseJSON);
    }
  });
}

function handleGetSync(resourceUrl, handler) {
  $.ajax({
    type: 'GET',
    url: resourceUrl,
    aysnc: false,
    cache: false,
    headers: {
      'Authorization': getJWT()
    },
    error: function (jqXHR, textStatus, error) {
      handler(jqXHR.status, jqXHR.responseJSON);
    },
    success: function (data, textStatus, jqXHR) {
      handler(jqXHR.status, jqXHR.responseJSON);
    }
  });
}


function handlePost(resourceUrl, body, handler) {
  $.ajax({
    type: 'POST',
    url: resourceUrl,
    aysnc: true,
    cache: false,
    headers: {
      'Authorization': getJWT(),
      'Content-Type': 'application/json'
    },
    data: body,
    error: function (jqXHR, textStatus, error) {
      handler(jqXHR.status, jqXHR.responseJSON);
    },
    success: function (data, textStatus, jqXHR) {
      handler(jqXHR.status, jqXHR.responseJSON);
    }
  });
}


function handlePut(resourceUrl, body, handler) {
  $.ajax({
    type: 'PUT',
    url: resourceUrl,
    aysnc: true,
    cache: false,
    headers: {
      'Authorization': getJWT(),
      'Content-Type': 'application/json'
    },
    data: body,
    error: function (jqXHR, textStatus, error) {
      handler(jqXHR.status, jqXHR.responseJSON);
    },
    success: function (data, textStatus, jqXHR) {
      handler(jqXHR.status, jqXHR.responseJSON);
    }
  });
}

function handleDelete(resourceUrl, handler) {
  $.ajax({
    type: 'DELETE',
    url: resourceUrl,
    aysnc: true,
    cache: false,
    headers: {
      'Authorization': getJWT()
    },
    error: function (jqXHR, textStatus, error) {
      handler(jqXHR.status, jqXHR.responseJSON);
    },
    success: function (data, textStatus, jqXHR) {
      handler(jqXHR.status, jqXHR.responseJSON);
    }
  });
}


export { getJWT, removeJWT, callAuth, handleGet, handlePost, handlePut, handleDelete, handleGetSync }

