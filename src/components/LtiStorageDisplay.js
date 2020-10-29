import React from "react";
import { Input, PageHeader, Button } from "antd";

import "antd/dist/antd.css";

import { useLtiStore, storeNewData } from "../utils/ltiEvents";

const LtiStorageDisplay = () => {
  const { status, data } = useLtiStore();

  return (
    <>
      <PageHeader
        title="LTI Storage Service Data"
        subTitle={`Status: ${status}`}
        extra={[
          <Button key="1" onClick={storeNewData}>
            Store New Data
          </Button>
        ]}
      />
      <Input.TextArea
        rows={10}
        value={JSON.stringify(data, null, 2)}
        style={{ fontFamily: '"Courier New", Courier, monospace' }}
      />
    </>
  );
};

export default LtiStorageDisplay;
