import { useBackend } from '../backend';
import { Box, AnimatedNumber, Button } from '../components';
import { Window } from '../layouts';

export const ShowAttributes = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    name,
    level,
  } = data;

  const attributes = data.attributes || [];
  const stats = data.stats || [];

  return (
    <Window
      title="Attributes"
      width={300}
      height={375}>
      <Window.Content>
        <Box lineHeight={1.75}>
          <b>{name}</b>
          <br /><br />
          Level <AnimatedNumber initial={1} value={level} />
          <br /><br />
          {attributes.map(attr => (
            <span key={attr}>
              {data[attr + "name"]}
              <span> </span>
              {data[attr + "level_text"]}
              <span>: </span>
              <AnimatedNumber initial={0} value={
                data[attr + "level_current"]
              } />
              <span>/</span>
              <AnimatedNumber initial={0} value={
                data[attr + "level_max"]
              } />
              {data[attr + "level_buff"] > 0 && (
                <>
                  <span> + </span>
                  <AnimatedNumber initial={0} value={
                    data[attr + "level_buff"]
                  } />
                </>
              )}
              {data[attr + "level_buff"] < 0 && (
                <>
                  <span> - </span>
                  <AnimatedNumber initial={0} value={
                    Math.abs(data[attr + "level_buff"])
                  } />
                </>
              )}
              <br />
            </span>)
          )}
          <br />
          {stats.map(stat => (
            <span key={stat}>
              {data[stat + "name"]}
              <span> : </span>
              <AnimatedNumber initial={0} value={
                data[stat + "base"]
              } />
              {data[stat + "bonus"] > 0 && (
                <>
                  <span> + </span>
                  <AnimatedNumber initial={0} value={
                    data[stat + "bonus"]
                  } />
                </>
              )}
              {data[stat + "bonus"] < 0 && (
                <>
                  <span> - </span>
                  <AnimatedNumber initial={0} value={
                    Math.abs(data[stat + "bonus"])
                  } />
                </>
              )}
              <br />
            </span>)
          )}
          <br />
          <Button
            content="View Gifts"
            textAlign="center"
            width="100%"
            onClick={() => act('show_gifts')}
          />
        </Box>
      </Window.Content>
    </Window>
  );
};
