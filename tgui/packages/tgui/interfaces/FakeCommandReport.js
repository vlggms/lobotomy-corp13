import { useBackend } from '../backend';
import { Button, Dropdown, Input, Section, Stack, TextArea } from '../components';
import { Window } from '../layouts';

export const FakeCommandReport = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    command_name,
    command_report_content,
    announce_contents,
  } = data;
  return (
    <Window
      title="Send Faked Command Report"
      width={325}
      height={425}
      theme="syndicate">
      <Window.Content>
        <Stack vertical>
          <Stack.Item>
            <Section title="Central Command Name:" textAlign="center">
              <Dropdown
                width="100%"
                selected={command_name}
                disabled={1} />
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title="Report Text:" textAlign="center">
              <TextArea
                height="200px"
                mb={1}
                value={command_report_content}
                onChange={(e, value) => act("update_report_contents", {
                  updated_contents: value,
                })} />
              <Stack vertical>
                <Stack.Item>
                  <Button.Checkbox
                    fluid
                    checked={announce_contents}
                    onClick={() => act("toggle_announce")}>
                    Announce Contents
                  </Button.Checkbox>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    fluid
                    icon="check"
                    color="good"
                    textAlign="center"
                    content="Submit Fake Report"
                    onClick={() => act("submit_report")} />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};