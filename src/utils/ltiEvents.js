import "regenerator-runtime/runtime.js";
import { useEffect, useState, useCallback } from "react";
import axios from "axios";

export const ltiStoreStates = {
  INITIALIZED: "initialized",
  DECRYPTING: "decrypting",
  ERROR: "error",
  SUCCESS: "success"
};

/*
* sendLtiMessage
*
* @experimental
*
* Sends a postMessage to the parent window
* with the specified arguments
*/
export function sendLtiMessage(messageType, data, clientId) {
  console.log(`Sending message ${messageType}`);
  window.parent.postMessage(
    {
      messageType,
      data,
      clientId
    },
    "*"
  );
}

/*
* refreshLtiStore
*
* @experimental
*
* Requests a refresh tool data from the
* experimental LTI Storage Service
*/
export function refreshLtiStore() {
  sendLtiMessage("lti.Storage.Fetch");
}

/*
* useLtiStore
*
* @experimental
*
* Provides two pieces of state:
* 1. data - The data retrieved from the experimental
*      LTI Store Service
* 2. status - The status of fetching the data from
*      the experimental LTI Store Service. See valid
*      values at `ltiStoreStates`.
*/
export function useLtiStore() {
  const [token, setToken] = useState();
  const [status, setStatus] = useState();
  const [data, setData] = useState({});

  const responseHandler = useCallback(event => {
    if (event.data.messageType == "lti.Storage.Fetch.Response") {
      setToken(event.data.data.encrypted_token);
    }
  });

  useEffect(() => {
    // Listen for Canvas LTI store responses
    window.addEventListener("message", responseHandler);

    // Request the LTI store from Canvas
    refreshLtiStore();

    setStatus(ltiStoreStates.INITIALIZED);

    return () => {
      window.removeEventListener("message", responseHandler);
    };
  }, []);

  useEffect(() => {
    if (!token) return;

    // Decrypt the token
    const decryptToken = async () => {
      try {
        setStatus(ltiStoreStates.DECRYPTING);
        const resp = await axios.post(
          "/decrypt",
          { token },
          { headers: { "content-type": "application/json" } }
        );
        setData(resp.data);
        setStatus(ltiStoreStates.SUCCESS);
      } catch (e) {
        setStatus(ltiStoreStates.ERROR);
      }
    };

    decryptToken();
  }, [token]);

  return { status, data };
}

// This is really just for demoing things
export function storeNewData() {
  sendLtiMessage(
    "lti.Storage.Set",
    {
      highContrast: true,
      lastPageSlug: "Demo123",
      random:
        Math.random()
          .toString(36)
          .substring(2, 15) +
        Math.random()
          .toString(36)
          .substring(2, 15)
    },
    10000000000057 // TODO: Read from site config
  );
  refreshLtiStore();
}