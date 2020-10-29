import React from "react";
import { Input, PageHeader, Button } from "antd";

import "antd/dist/antd.css";

import { useLtiStore, storeNewData } from "../utils/ltiEvents";

const LtiLaunchDisplay = ({ ltiLaunch }) => {
  return (
    <>
      <PageHeader
        title="LTI Storage Launch Data"
        subTitle={`Status: Launched`}
      />
      <Input.TextArea
        rows={10}
        value={JSON.stringify(ltiLaunch, null, 2)}
        style={{ fontFamily: '"Courier New", Courier, monospace' }}
      />
    </>
  );
};

export default LtiLaunchDisplay;
