import "regenerator-runtime/runtime.js";
import { useRef, useEffect, useState, useCallback } from "react";
import axios from "axios";

export const ltiStoreStates = {
  INITIALIZED: "initialized",
  DECRYPTING: "decrypting",
  ERROR: "error",
  SUCCESS: "success"
};

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

export function refreshLtiStore() {
  sendLtiMessage("lti.Storage.Fetch");
}

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
    refreshLtiStore()

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
        const resp = await axios.post("/decrypt", { token }, { headers: { 'content-type': 'application/json' } });
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
