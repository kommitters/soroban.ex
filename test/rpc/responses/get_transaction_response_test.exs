defmodule Soroban.RPC.GetTransactionResponseTest do
  use ExUnit.Case

  alias Soroban.RPC.GetTransactionResponse

  setup do
    not_found_result = %{
      status: :not_found,
      latest_ledger: "45075181",
      latest_ledger_close_time: "1677115742",
      oldest_ledger: "45070000",
      oldest_ledger_close_time: "1677000000"
    }

    success_result = %{
      status: :success,
      latest_ledger: "45075181",
      latest_ledger_close_time: "1677115742",
      oldest_ledger: "45070000",
      oldest_ledger_close_time: "1677000000",
      ledger: "45070700",
      created_at: "1677009000",
      application_order: 1,
      fee_bump: false,
      envelope_xdr:
        "AAAAAgAAAAC+B6dP3Y3Dk7cO+EXButf4j/a6NgZ8jhUdGd8Y4DLK1QAAJxMB1QqkAGOQiwAAAAEAAAAAAAAAAAAAAABkAG82AAAAAAAAAAEAAAAAAAAAAwAAAAAAAAABRVRYAAAAAACIVkm2vMC7wfGBUXcyyT5KMkEhZr0TEHmgyspvSQ+skwAAAAAFSbLgKG8eYQCUWuIAAAAAR3McdwAAAAAAAAAB4DLK1QAAAEDJvETQ3zLdr1RXE4KEQ+tlmWPh6zpFu/KrAQOrYrYSxpbhB5DPZRJnn+ROtU8TnZhZ6xQ136VrqNQm/+LUOD8D",
      result_xdr:
        "AAAAAAAAAGQAAAAAAAAAAQAAAAAAAAAMAAAAAAAAAAAAAAABAAAAAK36IZP1oM+KV7lU1u8H7BgGjwK6d6hPmU+zpA6rySi3AAAAAEbEAZ4AAAAAAAAAAVJCUk4AAAAArSYZWZeBIAHn1+M0WPwhehxZNiBgvJOx7IVykVOo39UAAAAAFZRBZACYloAAAAANAAAAAAAAAAAAAAAA",
      result_meta_xdr:
        "AAAAAgAAAAIAAAADArFrdQAAAAAAAAAAvgenT92Nw5O3DvhFwbrX+I/2ujYGfI4VHRnfGOAyytUAAAAADH94VAHVCqQAY5CKAAAACAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAQAAAAEzXjfgAAAAAAVJxmgAAAACAAAAAAAAAAAAAAAAAAAAAwAAAAACsWtzAAAAAGQAbxMAAAAAAAAAAQKxa3UAAAAAAAAAAL4Hp0/djcOTtw74RcG61/iP9ro2BnyOFR0Z3xjgMsrVAAAAAAx/eFQB1QqkAGOQiwAAAAgAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAABM1434AAAAAAFScZoAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAArFrdQAAAABkAG8eAAAAAAAAAAEAAAAGAAAAAwKxa3MAAAACAAAAAL4Hp0/djcOTtw74RcG61/iP9ro2BnyOFR0Z3xjgMsrVAAAAAEdzHHcAAAAAAAAAAUVUWAAAAAAAiFZJtrzAu8HxgVF3Msk+SjJBIWa9ExB5oMrKb0kPrJMAAAAABUnGaHLv1t0BpbXWAAAAAAAAAAAAAAAAAAAAAQKxa3UAAAACAAAAAL4Hp0/djcOTtw74RcG61/iP9ro2BnyOFR0Z3xjgMsrVAAAAAEdzHHcAAAAAAAAAAUVUWAAAAAAAiFZJtrzAu8HxgVF3Msk+SjJBIWa9ExB5oMrKb0kPrJMAAAAABUmy4ChvHmEAlFriAAAAAAAAAAAAAAAAAAAAAwKxa3UAAAAAAAAAAL4Hp0/djcOTtw74RcG61/iP9ro2BnyOFR0Z3xjgMsrVAAAAAAx/eFQB1QqkAGOQiwAAAAgAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAABM1434AAAAAAFScZoAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAArFrdQAAAABkAG8eAAAAAAAAAAECsWt1AAAAAAAAAAC+B6dP3Y3Dk7cO+EXButf4j/a6NgZ8jhUdGd8Y4DLK1QAAAAAMf3hUAdUKpABjkIsAAAAIAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAABAAAAATNeN+AAAAAABUmy4AAAAAIAAAAAAAAAAAAAAAAAAAADAAAAAAKxa3UAAAAAZABvHgAAAAAAAAADArFrcwAAAAEAAAAAvgenT92Nw5O3DvhFwbrX+I/2ujYGfI4VHRnfGOAyytUAAAABRVRYAAAAAACIVkm2vMC7wfGBUXcyyT5KMkEhZr0TEHmgyspvSQ+skwAAAE+W7pTjf/////////8AAAABAAAAAQAAAAFw+HPyAAAARkSap3YAAAAAAAAAAAAAAAECsWt1AAAAAQAAAAC+B6dP3Y3Dk7cO+EXButf4j/a6NgZ8jhUdGd8Y4DLK1QAAAAFFVFgAAAAAAIhWSba8wLvB8YFRdzLJPkoyQSFmvRMQeaDKym9JD6yTAAAAT5bulON//////////wAAAAEAAAABAAAAAXDzHW4AAABGRJqndgAAAAAAAAAAAAAAAA=="
    }

    failed_result = %{
      status: "FAILED",
      latest_ledger: "45075181",
      latest_ledger_close_time: "1677115742",
      oldest_ledger: "45070000",
      oldest_ledger_close_time: "1677000000",
      ledger: "45070700",
      created_at: "1677009000",
      application_order: 1,
      fee_bump: false,
      envelope_xdr:
        "AAAAAgAAAAC+B6dP3Y3Dk7cO+EXButf4j/a6NgZ8jhUdGd8Y4DLK1QAAJxMB1QqkAGOQiwAAAAEAAAAAAAAAAAAAAABkAG82AAAAAAAAAAEAAAAAAAAAAwAAAAAAAAABRVRYAAAAAACIVkm2vMC7wfGBUXcyyT5KMkEhZr0TEHmgyspvSQ+skwAAAAAFSbLgKG8eYQCUWuIAAAAAR3McdwAAAAAAAAAB4DLK1QAAAEDJvETQ3zLdr1RXE4KEQ+tlmWPh6zpFu/KrAQOrYrYSxpbhB5DPZRJnn+ROtU8TnZhZ6xQ136VrqNQm/+LUOD8D",
      result_xdr: "AAAAAAAAAGT////7AAAAAA==",
      result_meta_xdr:
        "AAAAAgAAAAIAAAADArFrdQAAAAAAAAAAvgenT92Nw5O3DvhFwbrX+I/2ujYGfI4VHRnfGOAyytUAAAAADH94VAHVCqQAY5CKAAAACAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAQAAAAEzXjfgAAAAAAVJxmgAAAACAAAAAAAAAAAAAAAAAAAAAwAAAAACsWtzAAAAAGQAbxMAAAAAAAAAAQKxa3UAAAAAAAAAAL4Hp0/djcOTtw74RcG61/iP9ro2BnyOFR0Z3xjgMsrVAAAAAAx/eFQB1QqkAGOQiwAAAAgAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAABM1434AAAAAAFScZoAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAArFrdQAAAABkAG8eAAAAAAAAAAEAAAAGAAAAAwKxa3MAAAACAAAAAL4Hp0/djcOTtw74RcG61/iP9ro2BnyOFR0Z3xjgMsrVAAAAAEdzHHcAAAAAAAAAAUVUWAAAAAAAiFZJtrzAu8HxgVF3Msk+SjJBIWa9ExB5oMrKb0kPrJMAAAAABUnGaHLv1t0BpbXWAAAAAAAAAAAAAAAAAAAAAQKxa3UAAAACAAAAAL4Hp0/djcOTtw74RcG61/iP9ro2BnyOFR0Z3xjgMsrVAAAAAEdzHHcAAAAAAAAAAUVUWAAAAAAAiFZJtrzAu8HxgVF3Msk+SjJBIWa9ExB5oMrKb0kPrJMAAAAABUmy4ChvHmEAlFriAAAAAAAAAAAAAAAAAAAAAwKxa3UAAAAAAAAAAL4Hp0/djcOTtw74RcG61/iP9ro2BnyOFR0Z3xjgMsrVAAAAAAx/eFQB1QqkAGOQiwAAAAgAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAABM1434AAAAAAFScZoAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAArFrdQAAAABkAG8eAAAAAAAAAAECsWt1AAAAAAAAAAC+B6dP3Y3Dk7cO+EXButf4j/a6NgZ8jhUdGd8Y4DLK1QAAAAAMf3hUAdUKpABjkIsAAAAIAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAABAAAAATNeN+AAAAAABUmy4AAAAAIAAAAAAAAAAAAAAAAAAAADAAAAAAKxa3UAAAAAZABvHgAAAAAAAAADArFrcwAAAAEAAAAAvgenT92Nw5O3DvhFwbrX+I/2ujYGfI4VHRnfGOAyytUAAAABRVRYAAAAAACIVkm2vMC7wfGBUXcyyT5KMkEhZr0TEHmgyspvSQ+skwAAAE+W7pTjf/////////8AAAABAAAAAQAAAAFw+HPyAAAARkSap3YAAAAAAAAAAAAAAAECsWt1AAAAAQAAAAC+B6dP3Y3Dk7cO+EXButf4j/a6NgZ8jhUdGd8Y4DLK1QAAAAFFVFgAAAAAAIhWSba8wLvB8YFRdzLJPkoyQSFmvRMQeaDKym9JD6yTAAAAT5bulON//////////wAAAAEAAAABAAAAAXDzHW4AAABGRJqndgAAAAAAAAAAAAAAAA=="
    }

    %{
      not_found_result: not_found_result,
      success_result: success_result,
      failed_result: failed_result
    }
  end

  describe "new/1" do
    test "when sucessful transaction", %{
      success_result:
        %{
          status: status,
          latest_ledger: latest_ledger,
          latest_ledger_close_time: latest_ledger_close_time,
          oldest_ledger: oldest_ledger,
          oldest_ledger_close_time: oldest_ledger_close_time,
          ledger: ledger,
          created_at: created_at,
          application_order: application_order,
          fee_bump: fee_bump,
          envelope_xdr: envelope_xdr,
          result_xdr: result_xdr,
          result_meta_xdr: result_meta_xdr
        } = success_result
    } do
      %GetTransactionResponse{
        status: ^status,
        latest_ledger: ^latest_ledger,
        latest_ledger_close_time: ^latest_ledger_close_time,
        oldest_ledger: ^oldest_ledger,
        oldest_ledger_close_time: ^oldest_ledger_close_time,
        ledger: ^ledger,
        created_at: ^created_at,
        application_order: ^application_order,
        fee_bump: ^fee_bump,
        envelope_xdr: ^envelope_xdr,
        result_xdr: ^result_xdr,
        result_meta_xdr: ^result_meta_xdr
      } = GetTransactionResponse.new(success_result)
    end

    test "when transaction not found ", %{
      not_found_result:
        %{
          status: status,
          latest_ledger: latest_ledger,
          latest_ledger_close_time: latest_ledger_close_time,
          oldest_ledger: oldest_ledger,
          oldest_ledger_close_time: oldest_ledger_close_time
        } = not_found_result
    } do
      %GetTransactionResponse{
        status: ^status,
        latest_ledger: ^latest_ledger,
        latest_ledger_close_time: ^latest_ledger_close_time,
        oldest_ledger: ^oldest_ledger,
        oldest_ledger_close_time: ^oldest_ledger_close_time
      } = GetTransactionResponse.new(not_found_result)
    end

    test "when transaction failed ", %{
      failed_result:
        %{
          status: status,
          latest_ledger: latest_ledger,
          latest_ledger_close_time: latest_ledger_close_time,
          oldest_ledger: oldest_ledger,
          oldest_ledger_close_time: oldest_ledger_close_time,
          ledger: ledger,
          created_at: created_at,
          application_order: application_order,
          fee_bump: fee_bump,
          envelope_xdr: envelope_xdr,
          result_xdr: result_xdr,
          result_meta_xdr: result_meta_xdr
        } = failed_result
    } do
      %GetTransactionResponse{
        status: ^status,
        latest_ledger: ^latest_ledger,
        latest_ledger_close_time: ^latest_ledger_close_time,
        oldest_ledger: ^oldest_ledger,
        oldest_ledger_close_time: ^oldest_ledger_close_time,
        ledger: ^ledger,
        created_at: ^created_at,
        application_order: ^application_order,
        fee_bump: ^fee_bump,
        envelope_xdr: ^envelope_xdr,
        result_xdr: ^result_xdr,
        result_meta_xdr: ^result_meta_xdr
      } = GetTransactionResponse.new(failed_result)
    end
  end
end
