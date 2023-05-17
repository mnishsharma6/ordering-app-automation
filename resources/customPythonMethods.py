from deepdiff import DeepDiff


class customPythonMethods:

    def compare_json_payloads(self, response_json, expected_json):
        diff = DeepDiff(response_json, expected_json, ignore_order=True, verbose_level=2)
        return diff.to_dict()
