defmodule Stellar.Horizon.Client.CannedUploadAccountRequests do
  @moduledoc false

  @base_url "https://horizon-testnet.stellar.org"

  def request(
        :get,
        @base_url <> "/accounts/GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3",
        _headers,
        _body,
        _opts
      ) do
    {:ok, 200, [], "{\"sequence\":\"1390916568875069\"}"}
  end

  def request(
        :get,
        @base_url <> "/accounts/GASY52GNGVKEMXSGH7VSCZQKRWQMIQD77J53KHXEBAV2BODWH6FDDZ3F",
        _headers,
        _body,
        _opts
      ) do
    {:ok, 200, [], "{\"sequence\":\"1390916568875069\"}"}
  end
end

defmodule Soroban.RPC.CannedUploadInvokeHostFunctionClientImpl do
  @moduledoc false

  @behaviour Soroban.RPC.Client.Spec

  @impl true
  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAgAAADIAYXNtAQAAAAFBDGABfgF+YAJ+fgF+YAN+fn4BfmAAAX5gBH5+fn4BfmABfgF/YAJ/fgAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       results: [
         %{
           auth: nil,
           events: nil,
           footprint:
             "AAAAAgAAAAYU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAABQAAAAHCoKrtqgxTcxBJ+F9JX+3Gvlw3NtYGwCu8hzxUsbupwIAAAAA",
           xdr: "AAAAEAAAAAEAAAACAAAADwAAAAVIZWxsbwAAAAAAAA8AAAAFd29ybGQAAAA="
         }
       ],
       cost: %{cpu_insns: "1048713", mem_bytes: "1201148"},
       latest_ledger: "475528"
     }}
  end

  def request(
        "simulateTransaction",
        _url,
        _headers,
        %{
          transaction:
            "AAAAAgAAAAAljujNNVRGXkY/6yFmCo2gxEB/+nu1HuQIK6C4dj+KMQAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAgAAADIAYXNtAQAAAAFBDGABfgF+YAJ+fgF+YAN+fn4BfmAAAX5gBH5+fn4BfmABfgF/YAJ/fgAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
        },
        _opts
      ) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       error: "error",
       cost: %{cpu_insns: "1048713", mem_bytes: "1201148"},
       latest_ledger: "475528"
     }}
  end

  @impl true
  def request("sendTransaction", _url, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})

    {:ok,
     %{
       status: "PENDING",
       hash: "308f5f3c7b2c0a690e7e19b6d14c22af87763f5ae483d6d1af43b9639732d206",
       latest_ledger: "602691",
       latest_ledger_close_time: "1683814245"
     }}
  end
end

defmodule Soroban.Contract.UploadContractCodeTest do
  use ExUnit.Case

  alias Soroban.Contract.UploadContractCode

  alias Soroban.RPC.{
    CannedUploadInvokeHostFunctionClientImpl,
    GetTransactionResponse,
    SendTransactionResponse,
    SimulateTransactionResponse
  }

  alias Stellar.Horizon.Client.CannedUploadAccountRequests

  setup do
    Application.put_env(:stellar_sdk, :http_client, CannedUploadAccountRequests)
    Application.put_env(:soroban, :http_client_impl, CannedUploadInvokeHostFunctionClientImpl)

    on_exit(fn ->
      Application.delete_env(:stellar_sdk, :http_client)
      Application.delete_env(:soroban, :http_client_impl)
    end)

    transaction_response =
      {:ok,
       %GetTransactionResponse{
         status: "SUCCESS",
         latest_ledger: "602722",
         latest_ledger_close_time: "1683814405",
         oldest_ledger: "601283",
         oldest_ledger_close_time: "1683806843",
         ledger: "602719",
         created_at: "1683814389",
         application_order: 1,
         fee_bump: nil,
         envelope_xdr:
           "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQAADg8AAAANAAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAgAAEGsAYXNtAQAAAAFBDGABfgF+YAJ+fgF+YAN+fn4BfmAAAX5gBH5+fn4BfmABfgF/YAJ/fgBgAn9/AX5gAn9/AGADf39/AGAAAGABfwACfxUBdgEzAAABaQE5AAABaQFhAAABaQE2AAABaQE3AAABaQE4AAEBaQE1AAEBdgE4AAABdgFDAAIBeAFiAAMBdgFIAAIBYgFNAAIBbQFDAAQBbQFCAAIBYQFfAAEBYQEwAAABbAEwAAABbAExAAABbAFfAAEBdgFHAAEBYgFKAAEDGxoFBgYBAQAHAQcIAAYJCgMAAAAAAAACAQsKCgUDAQARBhkDfwFBgIDAAAt/AEG9gMAAC38AQcCAwAALB4YBDgZtZW1vcnkCAAVoZWxsbwAfBmhlbGxvMgAjA3ZlYwAkBXR1cGxlACUDbWFwACYKZW51bV9wYXJhbQAnDG9wdGlvbl9wYXJhbQAoDHN0cnVjdF9wYXJhbQApBHN3YXAAKgNpbmMAKwFfAC4KX19kYXRhX2VuZAMBC19faGVhcF9iYXNlAwIKkBYaDgAgABCAgICAAEIgiKcLbwIBfwN+AkACQCABp0H/AXEiAkHFAEYNAAJAIAJBC0YNAEIBIQMMAgsgAUI/hyEEIAFCCIchBUIAIQMMAQtCACEDIAEQgYCAgAAhBSABEIKAgIAAIQQLIAAgBTcDCCAAIAM3AwAgAEEQaiAENwMAC2wCAX8CfgJAAkAgAadB/wFxIgJBxABGDQACQCACQQpGDQBCASEDDAILIAFCCIghBEIAIQFCACEDDAELQgAhAyABEIOAgIAAIQQgARCEgICAACEBCyAAIAQ3AwggACADNwMAIABBEGogATcDAAtFAAJAIABCgICAgICAgMAAfEL//////////wBWDQAgACAAhSAAQj+HIAGFhEIAUg0AIABCCIZCC4QPCyAAIAEQhYCAgAALMAACQCAAQv//////////AFYgAUIAUiABUBsNACAAQgiGQgqEDwsgACABEIaAgIAACxgAQYCAwIAAQQcQm4CAgAAgABCcgICAAAtgAgF/AX4jgICAgABBEGsiAiSAgICAACACIAAgARChgICAAAJAAkAgAigCAA0AIAIpAwghAwwBCyAArUIghkIEhCABrUIghkIEhBCUgICAACEDCyACQRBqJICAgIAAIAMLPAEBfyOAgICAAEEQayICJICAgIAAIAIgATcDCCACIAA3AwAgAkECEJ2AgIAAIQEgAkEQaiSAgICAACABCxoAIACtQiCGQgSEIAGtQiCGQgSEEJOAgIAAC2cBAn4CQAJAIAEpAwAiAhCAgICAAEKAgICAEFoNAEICIQIMAQsgAhCHgICAACEDIAEgAkKEgICAECACEICAgIAAQoCAgIBwg0IEhBCIgICAADcDAEIAIQILIAAgAzcDCCAAIAI3AwAL3AEBAn8jgICAgABBMGsiASSAgICAACABIAAQoICAgAACQCABKQMApw0AIAEpAwghACABQSBqQbiAwIAAQQUQoYCAgAACQCABKAIgDQAgASABKQMoNwMQIAEgADcDGEEAIQIDQAJAIAJBEEcNAEEAIQICQANAIAJBEEYNASABQSBqIAJqIAFBEGogAmopAwA3AwAgAkEIaiECDAALCyABQSBqQQIQnYCAgAAhACABQTBqJICAgIAAIAAPCyABQSBqIAJqQgI3AwAgAkEIaiECDAALCxCigICAAAALAAALJAEBfyAAIAE3AwggACABp0H/AXEiAkHLAEcgAkEOR3GtNwMAC/ABAwF/An4Bf0EAIQNCACEEA0ACQAJAAkAgAiADRw0AIAAgBEIIhkIOhDcDCEEAIQMMAQsCQCADQQlGDQBCASEFIAEgA2otAAAiBkHfAEYNAiAGrSEFAkACQAJAIAZBUGpB/wFxQQpJDQAgBkG/f2pB/wFxQRpJDQEgBkGff2pB/wFxQRpJDQJBASEDIABBATYCBCAAQQhqIAY2AgAMBAsgBUJSfCEFDAQLIAVCS3whBQwDCyAFQkV8IQUMAgsgAEEANgIEIABBCGogAjYCAEEBIQMLIAAgAzYCAA8LIANBAWohAyAFIARCBoaEIQQMAAsLBAAAAAsIABCJgICAAAsVAAJAIABC/wGDQs0AUQ0AAAALIAALxwEBAn8jgICAgABBIGsiASSAgICAAAJAAkAgAEL/AYNCzQBSDQBBACECAkADQCACQRBGDQEgAUEQaiACakICNwMAIAJBCGohAgwACwsgACABQRBqrUIghkIEhEKEgICAIBCKgICAABogASABKQMQEKCAgIAAIAEpAwCnDQAgASkDGCIAQv8Bg0IEUQ0BCwAACyABIAEpAwg3AxAgASAAQoCAgIBwg0IEhDcDGCABQRBqQQIQnYCAgAAhACABQSBqJICAgIAAIAALFQACQCAAQv8Bg0LOAFENAAAACyAAC8wCAQF/I4CAgIAAQcAAayIBJICAgIAAAkAgAEL/AYNCzQBSDQAgASAANwM4IAFBKGogAUE4ahCegICAACABKQMoIgBCAlENACAAQv////8Pg0IAUg0AIAFBGGogASkDMBCggICAACABKQMYpw0AAkACQAJAIAEpAyBBkIDAgACtQiCGQgSEQoSAgIAgEIuAgIAAQiCIpw4CAQADCyABKQM4EJWAgIAADQIgAUGLgMCAAEEEEJuAgIAANwM4IAFBOGpBARCdgICAACEADAELIAEpAzgQlYCAgABBAUsNASABQQhqIAFBOGoQnoCAgAAgASkDCCIAQgJRDQEgAEL/////D4NCAFINASABKQMQIgBC/wGDQgRSDQFBh4DAgABBBBCbgICAACAAQoCAgIBwg0IEhBCcgICAACEACyABQcAAaiSAgICAACAADwsAAAsuAQF/AkAgAEICUSIBDQAgAEL/AYNCBFENAAAAC0ICIABCgICAgHCDQgSEIAEbC+wBAgJ/AX4jgICAgABBIGsiASSAgICAAEEAIQICQANAIAJBEEYNASABQRBqIAJqQgI3AwAgAkEIaiECDAALCwJAAkAgAEL/AYNCzgBSDQAgAEGogMCAAK1CIIZCBIQgAUEQaq0iA0IghkIEhEKEgICAIBCMgICAABogASABKQMQEKCAgIAAIAEpAwCnDQAgASkDGCIAQv8Bg0IEUQ0BCwAACyABIAEpAwg3AxAgASAAQoCAgIBwg0IEhDcDGEGogMCAAK1CIIZCBIQgA0IghkIEhEKEgICAIBCNgICAACEAIAFBIGokgICAgAAgAAuzAwMBfwN+An8jgICAgABB4ABrIgMkgICAgAACQCAAQv8Bg0LQAFINACADQRhqIAEQloCAgAAgAygCGA0AIANBGGpBEGopAwAhASADKQMgIQQgAyACEJaAgIAAIAMoAgANACADQRBqKQMAIQIgAykDCCEFIAQgARCYgICAACEGIAMgBSACEJiAgIAANwNYIAMgBjcDUEEAIQcDQAJAIAdBEEcNAEEAIQcCQANAIAdBEEYNASADQTBqIAdqIANB0ABqIAdqKQMANwMAIAdBCGohBwwACwsgACADQTBqQQIQnYCAgAAQjoCAgAAaIANByABqIAI3AwAgAyAFNwNAIAMgATcDOCADIAQ3AzBBACEHA0ACQCAHQRBHDQBBACEHIANBMGohCAJAA0AgB0EQRg0BIANB0ABqIAdqIAgpAwAgCEEIaikDABCYgICAADcDACAIQRBqIQggB0EIaiEHDAALCyADQdAAakECEJ2AgIAAIQAgA0HgAGokgICAgAAgAA8LIANB0ABqIAdqQgI3AwAgB0EIaiEHDAALCyADQTBqIAdqQgI3AwAgB0EIaiEHDAALCwAAC8ECAwF/BH4CfyOAgICAAEHAAGsiAiSAgICAAAJAAkACQCAAQv8Bg0LQAFINACACQSBqIAEQl4CAgAAgAigCIA0AIAJBMGopAwAhAyACKQMoIQQgABCPgICAABoCQAJAIAAQmoCA",
         result_xdr:
           "AAAAAAAAAGQAAAAAAAAAAQAAAAAAAAAYAAAAAAAAAA0AAAAgQtAjKFI/GD4AoVvILmUtGNiMgqn+2QuDLQmXBcK8zRoAAAAA",
         result_meta_xdr:
           "AAAAAwAAAAIAAAADAAkyXwAAAAAAAAAAWjshnxvxlOorTtBJXCh3BalUvn2zeWxrcNMgwsFisdoAAAAXSHbTsAAAODwAAAAzAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAwAAAAAACTJFAAAAAGRc928AAAAAAAAAAQAJMl8AAAAAAAAAAFo7IZ8b8ZTqK07QSVwodwWpVL59s3lsa3DTIMLBYrHaAAAAF0h207AAADg8AAAANAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAAAkyXwAAAABkXPf1AAAAAAAAAAEAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAGQAAAAAAAAAAQAAAAAAAAAYAAAAAAAAAA0AAAAgQtAjKFI/GD4AoVvILmUtGNiMgqn+2QuDLQmXBcK8zRoAAAAAO2xKq3nsjVZsGkJ3uszaTKt+gwEFFy3BAUDgwEBTuZjLvEh1Deu4U1CTs96viKx/TP+HQlV2pY3iusdUrNtGFmf6iKuKFF24BJs+RzD9gekqYRCe+4YSSWSjC8WIixjiAAAAAA=="
       }}

    %{
      contract_id: "be4138b31cc5d0d9d91b53193d74316d254406794ec0f81d3ed40f4dc1b86a6e",
      source_public: "GBNDWIM7DPYZJ2RLJ3IESXBIO4C2SVF6PWZXS3DLODJSBQWBMKY5U4M3",
      source_secret: "SDRD4CSRGPWUIPRDS5O3CJBNJME5XVGWNI677MZDD4OD2ZL2R6K5IQ24",
      source_public_with_error: "GASY52GNGVKEMXSGH7VSCZQKRWQMIQD77J53KHXEBAV2BODWH6FDDZ3F",
      source_secret_with_error: "SDXKY6TSBNS7T2UJMHLIH4BWTP4EHR52HZTRNEKH33ML3ARJI2AKIPEC",
      wasm:
        <<0, 97, 115, 109, 1, 0, 0, 0, 1, 65, 12, 96, 1, 126, 1, 126, 96, 2, 126, 126, 1, 126, 96,
          3, 126, 126, 126, 1, 126, 96, 0, 1, 126, 96, 4, 126, 126, 126, 126, 1, 126, 96, 1, 126,
          1, 127, 96, 2, 127, 126>>,
      transaction_response: transaction_response,
      envelope_xdr:
        "AAAAAgAAAABaOyGfG/GU6itO0ElcKHcFqVS+fbN5bGtw0yDCwWKx2gAAAGQABPEIAAAAPgAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAgAAADIAYXNtAQAAAAFBDGABfgF+YAJ+fgF+YAN+fn4BfmAAAX5gBH5+fn4BfmABfgF/YAJ/fgAAAAAAAgAAAAYU0EuZrCKggMgcYHtwMuiHqnrYwhksO17kfjwJ8h2l3QAAABQAAAAHCoKrtqgxTcxBJ+F9JX+3Gvlw3NtYGwCu8hzxUsbupwIAAAAAAAAAAAAAAAAAAAAA"
    }
  end

  test "upload/2", %{
    wasm: wasm,
    source_secret: source_secret
  } do
    {:ok,
     %SendTransactionResponse{
       status: "PENDING",
       hash: "308f5f3c7b2c0a690e7e19b6d14c22af87763f5ae483d6d1af43b9639732d206",
       latest_ledger: "602691",
       latest_ledger_close_time: "1683814245",
       error_result_xdr: nil
     }} = UploadContractCode.upload(wasm, source_secret)
  end

  test "upload contract with simulate error", %{
    wasm: wasm,
    source_secret_with_error: source_secret_with_error
  } do
    {:ok,
     %SimulateTransactionResponse{
       error: "error"
     }} =
      UploadContractCode.upload(
        wasm,
        source_secret_with_error
      )
  end

  test "retrieve_unsigned_xdr_to_upload/2", %{
    wasm: wasm,
    source_public: source_public,
    envelope_xdr: envelope_xdr
  } do
    ^envelope_xdr = UploadContractCode.retrieve_unsigned_xdr_to_upload(wasm, source_public)
  end

  test "retrieve_unsigned_xdr_to_upload contract with simulate error", %{
    wasm: wasm,
    source_public_with_error: source_public_with_error
  } do
    {:ok,
     %SimulateTransactionResponse{
       error: "error"
     }} =
      UploadContractCode.retrieve_unsigned_xdr_to_upload(
        wasm,
        source_public_with_error
      )
  end

  test "get_wasm_id/1", %{
    transaction_response: transaction_response
  } do
    <<66, 208, 35, 40, 82, 63, 24, 62, 0, 161, 91, 200, 46, 101, 45, 24, 216, 140, 130, 169, 254,
      217, 11, 131, 45, 9, 151, 5, 194, 188, 205,
      26>> = UploadContractCode.get_wasm_id(transaction_response)
  end
end
